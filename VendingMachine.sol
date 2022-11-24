//SPDX-License-Identifier:MIT
// Contract created by Mohammed Rizwan

pragma solidity >=0.7.0 < 0.9.0;

contract VendingMachine {
    address payable public owner;
    mapping(address=>uint) public donutBalances;

    event amountReceived(address _buyerAddress, uint _amountPaid);

    constructor(){
        owner = payable (msg.sender);
        donutBalances[address(this)] = 100;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner can access this vending machine function.");
        _;
    }

    function getVMBalance() public view returns(uint) {
        return donutBalances[address(this)];
    }

    function checkContractBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    function restock(uint _addDonuts) public onlyOwner {
        donutBalances[address(this)] += _addDonuts;
    }

    function purchase(uint _quantity) public payable {
        require(msg.value == _quantity * 1 ether, "You must pay atleast 1 ether per donut");
        require (donutBalances[address(this)] >= _quantity, "Donut is not in stock");
        donutBalances[address(this)] -= _quantity;
        donutBalances[msg.sender] += _quantity;
        emit amountReceived(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}
