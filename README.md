# ECE6357-AES-Encryption

All .mat files are message/keys used to test the code. At this time, it is set up to only takes hex message/keys. A far as I can tell it is working correctly. The 128/192/256 indicates the key length of the sample.

AES.m - Used as a 1 shot to both encrypt/decrypt at the same time. Calls AES_encrypt.m & AES_decrypt.m

    AES_encrypt.m - The encryption as a function called by DES.m
    AES_decrypt.m - The decryption as a function called by DES.m

Stand alone versions used to find the time necessary for encryption/decryption. (Same as functions)

    AES_encrypt_.m
    AES_decrypt_.m

Support functions
 
    AES_byteSub.m - the byte substution layer
    AES_format.m - trying to format the input to take other than hex (may not work correctly, abandonded due to time constraints.)
    AES_gFxn.m - using the Galois function - better explainations in the function comments
    AES_keyAdd.m - adding the key to message
    AES_keyBuild.m - building all the keys needed to run the block cycles
    AES_mixCol.m - the mix columns layer
    AES_reorderKeys.m - for decryption, putting the keys in reverse order to make them easier to use.
    AES_sBox.m - sBox transformation
    AES_shiftRow.m - the shift row layer
    AES_to2Byte.m - converting the message into a 2 byte hex code arranged into a 16x1 array. 

