deps_config := \
	/home/soho/code/disk1/c50v4/svn/model_mtk/build/../build/sysdeps/linux/Config.in

.config include/config.h: $(deps_config)

$(deps_config):
