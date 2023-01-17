cethacea evm compile --compiler=yulc erc-721.yul > /dev/null && \
cethacea contract deploy --account=key1 erc-721.yul.bin