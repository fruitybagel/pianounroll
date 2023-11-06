#!/bin/bash

# Sys

libpath="/Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/libPyBridge_x64.dylib"

x86_64_offset=$(lipo -detailed_info "$libpath" | grep -A 4 "architecture x86_64" | grep "offset" | awk '{print $2}')
arm64_offset=$(lipo -detailed_info "$libpath" | grep -A 4 "architecture arm64" | grep "offset" | awk '{print $2}')

x86_64_symbol_offset=$(nm --arch=x86_64 -gU "$libpath" | grep __Z15addDefaultTypesP8TcPython | cut -d' ' -f 1)
arm64_symbol_offset=$(nm --arch=arm64 -gU "$libpath" | grep __Z15addDefaultTypesP8TcPython | cut -d' ' -f 1)

# echo "$x86_64_offset" "$arm64_offset" "$x86_64_symbol_offset" "$arm64_symbol_offset"

cp -f "$libpath" "${libpath}.new"

for i in {0..3}; do
    printf '\x1F\x20\x03\xD5' | dd of="${libpath}.new" bs=1 seek=$((0x${arm64_symbol_offset} + $arm64_offset + $i * 4)) conv=notrunc 2>/dev/null
done

printf '\x0F\x1F\x44\x00\x00' | dd of="${libpath}.new" bs=1 seek=$((0x${x86_64_symbol_offset} + $x86_64_offset + 10)) conv=notrunc 2>/dev/null

# File access

x86_64_symbol_offset=$(nm --arch=x86_64 -gU "$libpath" | grep __Z6doInitPcS_S_PFvPFvP19TPyModuleDefinitionPFP7_objectvEEE | cut -d' ' -f 1)
arm64_symbol_offset=$(nm --arch=arm64 -gU "$libpath" | grep __Z6doInitPcS_S_PFvPFvP19TPyModuleDefinitionPFP7_objectvEEE | cut -d' ' -f 1)

for i in {0..3}; do
    printf '\x1F\x20\x03\xD5' | dd of="${libpath}.new" bs=1 seek=$((0x${arm64_symbol_offset} + $arm64_offset + 252 + $i * 4)) conv=notrunc 2>/dev/null
done

printf '\x0F\x1F\x44\x00\x00' | dd of="${libpath}.new" bs=1 seek=$((0x${x86_64_symbol_offset} + $x86_64_offset + 229)) conv=notrunc 2>/dev/null

# dd if="$libpath" bs=1 skip=$((0x${x86_64_symbol_offset} + $x86_64_offset))  count=32 2>/dev/null | hexdump -C

# dd if="$libpath" bs=1 skip=$((0x${arm64_symbol_offset} + $arm64_offset))  count=32 2>/dev/null | hexdump -C

dd if="$libpath.new" bs=1 skip=$((0x${x86_64_symbol_offset} + $x86_64_offset))  count=512 2>/dev/null | hexdump -C

dd if="$libpath.new" bs=1 skip=$((0x${arm64_symbol_offset} + $arm64_offset))  count=512 2>/dev/null | hexdump -C

if ! [ -f "$libpath.bak" ]; then
    mv "$libpath" "$libpath.bak"
fi

mv "${libpath}.new" "$libpath"

sudo chown "$USER" "${libpath}"
# sudo chown "$USER" "${libpath}.new"

echo "Done. You may now close this window"