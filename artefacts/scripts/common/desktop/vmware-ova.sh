#!/usr/bin/env bash -eux

# Custom (All)

mkdir -p "artefacts/ovas/${INPUT}-vmware-iso/scratch";
ovftool "artefacts/ovas/${INPUT}-vmware-iso/${INPUT}.vmx" "artefacts/ovas/${INPUT}-vmware-iso/scratch/${INPUT}-vmware-iso.ovf";

cd "artefacts/ovas/${INPUT}-vmware-iso/scratch";
tar cf "../../${INPUT}-vmware-iso.ova" *.ovf *.mf *.vmdk;
cd ../../../..;

ovftool --schemaValidate "artefacts/ovas/${INPUT}-vmware-iso.ova";
rm -rf "artefacts/ovas/${INPUT}-vmware-iso";
