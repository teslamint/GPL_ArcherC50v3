#**************************************************************************** 
# 
#  Copyright(c) Shenzhen TP-LINK Technologies Co.Ltd. 
#  All Rights Reserved 
#  YuanShang <YuanShang@tp-link.com.cn> 
# 
#***************************************************************************
#!/bin/sh
command=""
build_dir=$(pwd)

# 1.parse args
for arg in $@
do
case "$arg" in
	MODEL=*	 ) m=${arg##*MODEL=};; #command=$command" "$arg;;
	env_build) env="1";;
	*	 ) command=$command" "$arg;;
esac
done

# 2.check MODEL
if [ "$m" = "" ]; then
	echo "You have to define MODEL"
	exit 1;
fi

# 3.env build
if [ "$env" = "1" ]; then
	echo build env
	if [ "$m" = W8980V1 ] || [ "$m" = W8970V1 ]; then
		cd $build_dir/../lantiq && make tools/install V=99 && make toolchain/install V=99
	elif [ "$m" = WR843V1 ]; then
		cd $build_dir/../board9341/build && make BOARD_TYPE=db12x toolchain_build
	elif [ "$m" = WR740V2 ]; then
		cd $build_dir/../board9341/build && make BOARD_TYPE=ap121-2.6.31 toolchain_build
	elif [ "$m" = C2V1 ] || [ "$m" = C20iV1 ]; then
		echo prepare the xz tool...
		cd $build_dir/../mtk_ApSoC_4120/tools/toolchain && \
		tar -jxf xz-5.0.3.tar.bz2 && cd xz-5.0.3/ && \
		./configure --prefix=$build_dir/../mtk_ApSoC_4120/tools/toolchain/xz-5.0.3/inst --disable-xz --disable-xzdec --disable-lzmadec \
		--disable-lzmainfo --disable-lzma-links --disable-scripts --enable-shared=no && \
		make clean && \
		make all && \
		make install

		echo prepare the lzma tool...
		test -e $build_dir/../mtk_ApSoC_4120/tools/lzma || (cd $build_dir/../mtk_ApSoC_4120/tools/toolchain/ && \
		tar -zxf lzma-4.32.7.tar.gz && cd lzma-4.32.7/ && \
		./configure --enable-shared=no && \
		make clean && make && \
		cp -rf src/lzma/lzma $build_dir/../mtk_ApSoC_4120/tools/)

		echo prepare the squashfs 4.2...
		(test -e $build_dir/../mtk_ApSoC_4120/tools/mksquashfs4.2 && \
		test -e $build_dir/../mtk_ApSoC_4120/tools/unsquashfs) || \
		(cd $build_dir/../mtk_ApSoC_4120/tools/toolchain/ && \
		tar -jxf squashfs4.2.tar.bz2 && cd squashfs4.2/squashfs-tools && \
		cp -rf $build_dir/../mtk_ApSoC_4120/tools/toolchain/xz-5.0.3/inst/lib/liblzma.* ./ && \
		cp -rf $build_dir/../mtk_ApSoC_4120/tools/toolchain/xz-5.0.3/inst/include/* ./ && \
		make clean && \
		make all && \
		cp -rf mksquashfs $build_dir/../mtk_ApSoC_4120/tools/mksquashfs4.2 && \
		cp -rf unsquashfs $build_dir/../mtk_ApSoC_4120/tools/)
	fi
	cd $build_dir && make MODEL=$m env_build
fi

# 4.main command
if [ "$command" != "" ]; then
	cd $build_dir && make MODEL=$m $command
fi

exit 0
