arm_config=(--arch=arm --enable-cross-compile --disable-iwmmxt --cross-prefix=/opt/android-ndk/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi- --extra-ldflags=-L/opt/android-ndk/platforms/android-9/arch-arm/usr/lib\ --sysroot=/opt/android-ndk/platforms/android-9/arch-arm)
x86_config=(--arch=x86)

#for arch in armv7-a-neon ; do
for arch in x86 armv7-a-neon armv7-a armv6j armv6-vfp armv5te armv5te-vfp armv4t ; do
	config=(--disable-postproc --disable-muxers --disable-hwaccels --disable-devices --disable-encoders --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffserver --disable-swscale --disable-avdevice --disable-avfilter --target-os=linux)
	if [ "${arch/arm}" != "$arch" ] ; then
		arm_cflags="-I/opt/android-ndk/platforms/android-9/arch-arm/usr/include -mthumb $(make -npf $ANDROID_BUILD_TOP/build/core/combo/arch/arm/$arch.mk | grep arch_variant_cflags | sed 's/.*:= //g')"
		config=("${config[@]}" "${arm_config[@]}" "--extra-cflags=$arm_cflags")
#		if [ "${arch/neon}" != "$arch" ] ; then
#			config=("${config[@]}" --enable-neon)
#		else
#			config=("${config[@]}" --disable-neon)
#			if [ "${arch/vfp}" != "$arch" ] ; then
#				config=("${config[@]}" --enable-armvfp)
#			else
#				config=("${config[@]}" --disable-armvfp)
#			fi
#		fi
#		if [ "${arch/armv[67]}" != "$arch" ] ; then
#			config=("${config[@]}" --enable-armv6 --enable-armv6t2)
#		else
#			config=("${config[@]}" --disable-armv6 --disable-armv6t2)
#		fi
	else
		config=("${config[@]}" "${x86_config[@]}")
	fi
	./configure "${config[@]}" || exit 1
	if [ "${arch/armv[567]}" != "$arch" ] ; then
		sed -i 's/CONFIG_THUMB 0/CONFIG_THUMB 1/g' config.h
		sed -i 's/!CONFIG_THUMB/CONFIG_THUMB/g' config.mak
	fi
	egrep '^(!?CONFIG|ARCH|!?HAVE)' config.mak >config-$arch.mak
	sed 's/restrict restrict/restrict __restrict__/g' config.h libavutil/avconfig.h >config-$arch.h
done
