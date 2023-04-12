#!/bin/bash

assets=./workspace/code/Week02/assets
scriptassets=./workspace/repo/code/Week02/040202/
keypath=./workspace/repo/code/Week02/040202/keys/
name="$1"
collateral="$2"
txin="$3"

pp="$scriptassets/protocol-parameters.json"
body="$scriptassets/collect-gift.txbody"
tx="$scriptassets/collect-gift.tx"

# Query the protocol parameters \

cardano-cli query protocol-parameters \
    --testnet-magic 2 \
    --out-file "./workspace/repo/code/Week02/040202/protocol-parameters.json"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "0b91e9490ee12542eda1ea602f4bf8b8635f9c1d2b4e90bd4814f83b7501797a#0" \
    --tx-in-script-file "./workspace/repo/code/Week02/assets/gift.plutus" \
    --tx-in-inline-datum-present \
    --tx-in-redeemer-file "./workspace/repo/code/Week02/assets/unit.json" \
    --tx-in-collateral "b205bd2f94c6a4958562772f8672ad4f43eddb9c10856b38fabd6682cb9aca69#0" \
    --change-address "addr_test1vqt9aq65jupw7exyg0h5xhglapje8rkmcvxrpklgz0utuxqjw94vq" \
    --protocol-params-file "./workspace/repo/code/Week02/040202/protocol-parameters.json" \
    --out-file "./workspace/repo/code/Week02/040202/collect-gift.txbody"
    
# Sign the transaction
cardano-cli transaction sign \
    --tx-body-file "./workspace/repo/code/Week02/040202/collect-gift.txbody" \
    --signing-key-file "./workspace/repo/code/Week02/040202/keys/userReceivingGift.skey" \
    --testnet-magic 2 \
    --out-file "./workspace/repo/code/Week02/040202/collect-gift.tx"

# Submit the transaction
cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file "./workspace/repo/code/Week02/040202/collect-gift.tx"

tid=$(cardano-cli transaction txid --tx-file "./workspace/repo/code/Week02/040202/collect-gift.tx")
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"

# ORIGINAL CODE
# assets=/workspace/code/Week02/assets
# keypath=/workspace/keys
# name="$1"
# collateral="$2"
# txin="$3"

# pp="$assets/protocol-parameters.json"
# body="$assets/collect-gift.txbody"
# tx="$assets/collect-gift.tx"

# # Query the protocol parameters \

# cardano-cli query protocol-parameters \
#     --testnet-magic 2 \
#     --out-file "$pp"

# # Build the transaction
# cardano-cli transaction build \
#     --babbage-era \
#     --testnet-magic 2 \
#     --tx-in "$txin" \
#     --tx-in-script-file "$assets/gift.plutus" \
#     --tx-in-inline-datum-present \
#     --tx-in-redeemer-file "$assets/unit.json" \
#     --tx-in-collateral "$collateral" \
#     --change-address "$(cat "$keypath/$name.addr")" \
#     --protocol-params-file "$pp" \
#     --out-file "$body"
    
# # Sign the transaction
# cardano-cli transaction sign \
#     --tx-body-file "$body" \
#     --signing-key-file "$keypath/$name.skey" \
#     --testnet-magic 2 \
#     --out-file "$tx"

# # Submit the transaction
# cardano-cli transaction submit \
#     --testnet-magic 2 \
#     --tx-file "$tx"

# tid=$(cardano-cli transaction txid --tx-file "$tx")
# echo "transaction id: $tid"
# echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"