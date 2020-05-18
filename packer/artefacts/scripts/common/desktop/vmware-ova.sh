#!/usr/bin/env bash -eux

# Custom (All)

mkdir -p "packer/artefacts/ovas/${INPUT}-vmware-iso/scratch";
ovftool "packer/artefacts/ovas/${INPUT}-vmware-iso/${INPUT}.vmx" "packer/artefacts/ovas/${INPUT}-vmware-iso/scratch/${INPUT}-vmware-iso.ovf";

cd "packer/artefacts/ovas/${INPUT}-vmware-iso/scratch";
tar cf "../../${INPUT}-vmware-iso.ova" *.ovf *.mf *.vmdk;
cd ../../../../..;

ovftool --schemaValidate "packer/artefacts/ovas/${INPUT}-vmware-iso.ova";
openssl dgst -sha256 "packer/artefacts/ovas/${INPUT}-vmware-iso.ova" | cut -d ' ' -f 2 > "packer/artefacts/ovas/${INPUT}-vmware-iso.ova.checksum-sha256.txt";

rm -rf "packer/artefacts/ovas/${INPUT}-vmware-iso";
