object "TokenReceiver" {
    code {
        datacopy(0,dataoffset("runtime"),datasize("runtime"))
        return(0,datasize("runtime"))
    }
    object "runtime" {

        code {
            switch shr(0xe0, calldataload(0x0))
            case 0x150b7a02 {
                // function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4)
                
                // [4][20][20][20][20][..data]
                // 4+20+20+20+20

                let dataOffset := calldataload(0x64)
                let payload:=calldataload(add(0x24,dataOffset)) // first slot of bytes data
                let magic := 0x150b7a02
                mstore(0,magic)
                return(0,0x20)
                
            }
            default {
                revert(0,0)
            }
        }
    }
}