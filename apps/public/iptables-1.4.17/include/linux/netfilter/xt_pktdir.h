#ifndef _XT_PKTDIR_H
#define _XT_PKTDIR_H

enum packet_dir
{
	DIR_ORIGINAL = 0,
	DIR_REPLY = 1
};

struct xt_pktdir_info {
    enum packet_dir dir;
    char opt[10];
};
#endif /*_XT_PKTDIR_H*/
