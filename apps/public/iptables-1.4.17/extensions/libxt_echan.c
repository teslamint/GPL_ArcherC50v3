#include <stdio.h>
#if defined(__GLIBC__) && __GLIBC__ == 2
#include <net/ethernet.h>
#else
#include <linux/if_ether.h>
#endif
#include <xtables.h>
#include <linux/netfilter/xt_echan.h>

enum {
	O_FWD = 0,
};

static void echan_help(void)
{
	printf(
"echan match options:\n"
"configure the function by /proc/tplink/echan\n"
"\t\tformat: -[a/d] ip1 ip2 ip3 ip4 iport eport eportend proto\n"
"\t\tnote: the seperater is \"blank\"\n");
}

#define s struct xt_echan_info
static const struct xt_option_entry echan_opts[] = {
	XTOPT_TABLEEND,
};
#undef s

static void echan_parse(struct xt_option_call *cb)
{
	struct xt_echan_info *echaninfo = cb->data;
}

static void
echan_print(const void *ip, const struct xt_entry_match *match, int numeric)
{
	const struct xt_echan_info *info = (void *)match->data;
		printf(" ECHAN RUNNING");
}

static void echan_save(const void *ip, const struct xt_entry_match *match)
{
	const struct xt_echan_info *info = (void *)match->data;

	printf(" --echan-source");
}

static struct xtables_match echan_match = {
	.family		= NFPROTO_UNSPEC,
 	.name		= "echan",
	.version	= XTABLES_VERSION,
	.size		= XT_ALIGN(sizeof(struct xt_echan_info)),
	.userspacesize	= XT_ALIGN(sizeof(struct xt_echan_info)),
	.help		= echan_help,
	.x6_parse	= echan_parse,
	.print		= echan_print,
	.save		= echan_save,
	.x6_options	= echan_opts,
};

void _init(void)
{
	xtables_register_match(&echan_match);
}

