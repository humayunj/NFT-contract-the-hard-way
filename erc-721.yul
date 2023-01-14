object "NFT" {
    code{
        sstore(0x0,caller()) // contract owner
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
                returnUint(balanceOf(calldataload(0x4)))
            }
            case 0x6352211e{   
                /**
                function ownerOf(uint256 _tokenId) external view returns (address);
                 */ 
                returnUint(ownerOf(calldataload(0x4)))
            }

            case 0x01ffc9a7 {
                /**
                ERC-165
                function supportsInterface(bytes4 interfaceID) external view returns (bool);
                
                */
                returnUint(supportsInterface(calldataload(0x4)))
            }
            case 0x6a627842 {
                /**
                Non-EIP
                function mint(address to) public returns (uint256 tokenId)
                */
                returnUint(mint(calldataload(0x4)))
            }
            default {
                revert (0,0)
            }

            //---------------------
            /** Methods */
            function balanceOf(owner) -> blnc {
                blnc := sload(offsetOwnerToBalance(owner))
            }
            function ownerOf(tokenId) -> owner {
                owner := sload(offsetTokenToAddress(tokenId))
            }

            function mint(to) -> tokenId {
                
                tokenId := counterIncreament()
                sstore(offsetTokenToAddress(tokenId),to)
                increamentBalance(to)
                // emit event
            }


            function supportsInterface(interface) -> supports {
                
                switch interface 
                case 0x80ac58cd {
                    supports := 1
                }
                case 0x01ffc9a7 {
                    supports := 1
                }
                default {
                    supports := 0
                }
                
            }
            
           

            //----------------------
            /** Storage Offsets */
            function offsetContractOwner() ->p {
                p := 0x0
            }
            function offsetTokenToAddress(tokenId) -> addr {
                addr := add(0x1000,tokenId)
            }
            function offsetOwnerToBalance(owner) -> offset {
                /**
                    offset = keccak(owner.concat(owner))
                    (Solidity docs inspired)
                */
                mstore(0,owner)
                mstore(0x20,owner)
                offset := keccak256(0,0x40)
            }
            function offsetTokenCounter() -> offset {
                offset := 0x20 // after the owner
            }
            
            
            
            //---------------------
            /** Utilities */
            function returnUint(value) {
                mstore(0,value)
                return(0,0x20)
            }
            function counterValue() -> val {
                val:= sload(0x20)
            }
            function counterIncreament() -> val {
                val:= sload(0x20)
                sstore(0x20,add(val,1))
            }
            function increamentBalance(owner){
                let offset := offsetOwnerToBalance(owner)
                sstore(offset,add(sload(offset),1))
            }
            
        }
    }
}