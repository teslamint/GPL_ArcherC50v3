#include <stdio.h>
#if defined(__GLIBC__) && __GLIBC__ == 2
#include <net/ethernet.h>
#else
#include <linux/if_ether.h>
#endif
#include <xtables.h>
#include <linux/netfilter/xt_pktdir.h>

enum {
	O_FWD = 0,
};

static void pktdir_help(void)
{
	printf(
"pktdir match options:\n"
"[!] --dir [original/reply]\n"
"		original: match the packets sended from the original direction"
"		reply   : match the packets sended from the reply direction");
}

#define s struct xt_pktdir_info
static const struct xt_option_entry pktdir_opts[] = {
	{.name = "dir", .id = O_FWD, .type = XTTYPE_STRING,
	 .flags = XTOPT_MAND | XTOPT_PUT,
	 XTOPT_POINTER(s, opt)},
	XTOPT_TABLEEND,
};
#undef s

static void pktdir_parse(struct xt_option_call *cb)
{
	struct xt_pktdir_info *pktdirinfo = cb->data;

	xtables_option_parse(cb);
	
	printf("==> pktdir_parse, opt: %s\n", pktdirinfo->opt);

	if (strcmp(pktdirinfo->opt, "reply") == 0)
	{
		pktdirinfo->dir = DIR_REPLY;
	}
	else if (strcmp(pktdirinfo->opt, "original") == 0)
	{
		pktdirinfo->dir = DIR_ORIGINAL;
	}
	else 
	{
		iptables_exit_error(PARAMETER_PROBLEM, "Illegal parameter! Only [original/reply] allowed!\n");
	}
}

static void
pktdir_print(const void *ip, const struct xt_entry_match *match, int numeric)
{
	const struct xt_pktdir_info *info = (void *)match->data;

	if (info->dir == DIR_ORIGINAL)
		printf(" Matching packets of original direction");
	else if (info->dir == DIR_REPLY)
		printf(" Matching packets of reply direction");
}

static void pktdir_save(const void *ip, const struct xt_entry_match *match)
{
	const struct xt_pktdir_info *info = (void *)match->data;

	printf(" --pktdir-source");
}

static struct xtables_match pktdir_match = {
	.family		= NFPROTO_UNSPEC,
 	.name		= "pktdir",
	.version	= XTABLES_VERSION,
	.size		= XT_ALIGN(sizeof(struct xt_pktdir_info)),
	.userspacesize	= XT_ALIGN(sizeof(struct xt_pktdir_info)),
	.help		= pktdir_help,
	.x6_parse	= pktdir_parse,
	.print		= pktdir_print,
	.save		= pktdir_save,
	.x6_options	= pktdir_opts,
};

void _init(void)
{
	xtables_register_match(&pktdir_match);
}
