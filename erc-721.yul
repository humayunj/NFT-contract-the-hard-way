object "NFT" {
    code{
        sstore(0x0,caller()) // contract creator
        datacopy(0,dataoffset("runtime"),datasize("runtime"))
        return(0x0,datasize("runtime"))
    }
    object "runtime"{
        code {
            switch shr(0xe0,calldataload(0))
            case 0x70a08231 {
            /**
                function balanceOf(address _owner) external view returns (uint256); 
            */
                mstore(0x0,0x0)
                return (0x0,0x20)
            }
            case 0x6352211e{
            /**
                function ownerOf(uint256 _tokenId) external view returns (address);
            */
                
                mstore(0,sload(0x0))
                return (0x0,0x20)
            }
        }
    }
}