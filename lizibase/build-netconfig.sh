#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        netcfg-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=1
P0PORT=7051
P1PORT=8051
CAPORT=7054
PEERPEM=crypto-config/peerOrganizations/org1.liziblockchain.com/tlsca/tlsca.org1.liziblockchain.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org1.liziblockchain.com/ca/ca.org1.liziblockchain.com-cert.pem
# PEERPEM=crypto-config/peerOrganizations/org2.liziblockchain.com/tlsca/tlsca.org2.liziblockchain.com-cert.pem
# CAPEM=crypto-config/peerOrganizations/org2.liziblockchain.com/ca/ca.org2.liziblockchain.com-cert.pem

echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > netconfig-org1.yaml

