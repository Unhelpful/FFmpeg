arm_sysroot=/opt/android-ndk/platforms/android-9/arch-arm
arm_config=(--arch=arm --enable-cross-compile --disable-iwmmxt --cross-prefix=/opt/android-ndk/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-)
x86_config=(--arch=x86)

#for arch in armv7-a-neon ; do
for arch in x86 armv7-a-neon armv7-a armv6j armv6-vfp armv5te armv5te-vfp armv4t ; do
	config=(--disable-protocols --disable-filters --disable-postproc --disable-muxers --disable-hwaccels --disable-devices --disable-encoders --disable-ffmpeg --disable-ffplay --disable-ffserver --disable-swscale --disable-avdevice --disable-avfilter --target-os=linux)
	if [ "${arch/arm}" != "$arch" ] ; then
		arm_cflags="-mandroid $(make -npf $ANDROID_BUILD_TOP/build/core/combo/arch/arm/$arch.mk BUILD_COMBOS=$ANDROID_BUILD_TOP/build/core/combo/ | grep arch_variant_cflags | sed 's/.*:= //g')"
		config=("${config[@]}" "--sysroot=${arm_sysroot}") 
		if [ "${arch/armv4}" = "$arch" ] ; then
			config=("${config[@]}" --enable-thumb)
		fi
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
	cat config.mak | egrep -v '^(CC|AS|LD|RANLIB|AR|SRC_PATH|DEP_CC)\s*:?=' | sed -re '/\w+FLAGS/ s/--sysroot=\S+//g' -e '/\w+FLAGS/ s/^/FF/g' >config-$arch.mak
	cat config.h libavutil/avconfig.h >config-$arch.h
done
