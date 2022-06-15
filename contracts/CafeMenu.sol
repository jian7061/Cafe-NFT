//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CafeMenu is Ownable {
    //Single material
    struct Material {
        string name;
        string unit;
        uint32 defaultAmount;
    }
    Material[] public materials;

    string[] public products;
    uint public productId;

    //Single recipe
    struct Recipe {
        uint128 materialId;
        uint128 amount;
    }
    Recipe[] public recipes;

    mapping(uint => Recipe[]) public productToRecipes;

    constructor() {
        materials.push(Material("Water","ml",50));
        materials.push(Material("Milk","ml",50));
        materials.push(Material("Espresso","shot",1));
        materials.push(Material("WhippedCream","pump",1));
    }

    function addMaterial(
        string memory _name,
        string memory _unit,
        uint32 _defaultAmount
        ) public onlyOwner returns(bool success){
            //check that new material is unique   
            for(uint i=0; i < materials.length; i++) {
                require(keccak256(abi.encodePacked(materials[i].name)) != keccak256(abi.encodePacked(_name)),
                string(abi.encodePacked(_name,"already exists")));
            }
            
            materials.push(Material(_name, _unit, _defaultAmount));
            return true;
    }

    function addProductWithRecipe (string memory _name, Recipe[] calldata _recipes) public onlyOwner returns(bool success) {
            //check if there's material of a new product's recipe 
            for(uint i=0; i < _recipes.length; i++) {
                require(_recipes[i].materialId < materials.length,
                string(abi.encodePacked(_name,"does not exist")));
            }
            
            //check that new product is unique
            for(uint i=0; i < products.length; i++){
                require(keccak256(abi.encodePacked(products[i])) != keccak256(abi.encodePacked(_name)),
                string(abi.encodePacked(_name,"already exists")));
            }

            products.push(_name);
            uint productId = products.length -1;
            for(uint i=0; i <_recipes.length; i++){
                productToRecipes[productId].push(_recipes[i]);
            }

            console.log("%s is creates with %d materials", _name, _recipes.length);
            return true;

    }

    function getRecipes(uint _productId) external view returns(Recipe[] memory) {
        require(_productId < products.length,
        string(abi.encodePacked(_productId,"does not exist")));

        return productToRecipes[_productId];
    }

    // function equals(string memory a, string memory b) internal pure returns(bool) {
    //     if() {
    //         return false;
    //     } else {
    //         return 
    //     }
    // }
}
