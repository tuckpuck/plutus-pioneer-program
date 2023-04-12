#!/bin/bash

# This is for creating user addressses, creating an address for the gift script, and sending money to script address

# Create userSendingGift keys
path=./workspace/repo/code/Week02/040202/keys/
mkdir -p "$path"

vkey="$path/userSendingGift.vkey"
skey="$path/userSendingGift.skey"
addr="$path/userSendingGift.addr"

cardano-cli address key-gen --verification-key-file "$vkey" --signing-key-file "$skey" &&
cardano-cli address build --payment-verification-key-file "$vkey" --testnet-magic 2 --out-file "$addr"

# Create userReceivingGift keys
path=./workspace/repo/code/Week02/040202/keys/
mkdir -p "$path"

vkey="$path/userReceivingGift.vkey"
skey="$path/userReceivingGift.skey"
addr="$path/userReceivingGift.addr"

cardano-cli address key-gen --verification-key-file "$vkey" --signing-key-file "$skey" &&
cardano-cli address build --payment-verification-key-file "$vkey" --testnet-magic 2 --out-file "$addr"

# Send test ada to UserSendingGift
# Then, query using this command:
cardano-cli query utxo --testnet-magic 2 --address addr_test1vp8u4t8jhs4zdmas3lk4twdtz3kcuh7n7lmu53m6wdzkncgy3k

# Build gift address. Make a script address from the serialzed script. 
cardano-cli address build 
--payment-script-file "./workspace/repo/code/Week02/assets/gift.plutus" 
--testnet-magic 2 
--out-file "./workspace/repo/code/Week02/040202/gift.addr"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "0a7270ed42026bfda15e7c8343bef12f166aa86960864433d4a19c177ab51d71#0" \
    --tx-out "$(cat "./workspace/repo/code/Week02/040202/gift.addr") + 3000000 lovelace" \
    --tx-out-inline-datum-file "./workspace/repo/code/Week02/assets/unit.json" \
    --change-address "$(cat "./workspace/repo/code/Week02/040202/keys/userSendingGift.addr")" \
    --out-file "./workspace/repo/code/Week02/040202/gift.txbody"


# Sign the transaction
cardano-cli transaction sign \
    --tx-body-file "./workspace/repo/code/Week02/040202/gift.txbody" \
    --signing-key-file "./workspace/repo/code/Week02/040202/keys/userSendingGift.skey" \
    --testnet-magic 2 \
    --out-file "./workspace/repo/code/Week02/040202/gift.tx"

# Submit the transaction
cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file "./workspace/repo/code/Week02/040202/gift.tx"

tid=$(cardano-cli transaction txid --tx-file "./workspace/repo/code/Week02/040202/gift.tx")
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"


# ORIGINAL CODE
# assets=/workspace/code/Week02/assets
# keypath=/workspace/keys
# name="$1"
# txin="$2"
# body="$assets/gift.txbody"
# tx="$assets/gift.tx"

# # Build gift address 
# cardano-cli address build \
#     --payment-script-file "$assets/gift.plutus" \
#     --testnet-magic 2 \
#     --out-file "$assets/gift.addr"

# # Build the transaction
# cardano-cli transaction build \
#     --babbage-era \
#     --testnet-magic 2 \
#     --tx-in "$txin" \
#     --tx-out "$(cat "$assets/gift.addr") + 3000000 lovelace" \
#     --tx-out-inline-datum-file "$assets/unit.json" \
#     --change-address "$(cat "$keypath/$name.addr")" \
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