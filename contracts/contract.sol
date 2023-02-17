//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract RentCars {

    address payable public carOwner;

    struct Car {
    address rentedBy;
    uint rentedTime;
}
    Car[3] public cars;

    event ACarRented(uint carIndex, address renter);
    event ACarTurnedIn(uint carIndex, uint amountDue);

    error AllCarsRented(string message);
    error NotEnoughEtherSent(uint amount);

    constructor() {
        carOwner = payable(msg.sender);
    }

    modifier ownerNotAllowed {
        require(msg.sender != carOwner, "Car owner cannot rent his own car");
        _;
    }

    function rentACar() public ownerNotAllowed {
        for(uint i = 0; i < 3; i++) {
            if(cars[i].rentedBy == address(0)) {
                cars[i].rentedBy = msg.sender;
                cars[i].rentedTime = block.timestamp;

                emit ACarRented(i, msg.sender);
                return;
            }
        }

        revert AllCarsRented({message:"All cars are already rented"});
    }

    function turnInCar(uint carIndex) public payable ownerNotAllowed {
        require(carIndex>=0 && carIndex<3, "Car index should be in between 0 and 3");
   
        Car storage car = cars[carIndex];
        require(car.rentedBy == msg.sender, "You cannot turn in a car rented by someone else");

        cars[carIndex].rentedBy = address(0);
        uint rentedSeconds = block.timestamp - cars[carIndex].rentedTime;
        uint amountDue = 1 ether * rentedSeconds;
        assert(msg.value == amountDue);

        cars[carIndex].rentedTime = 0;
        carOwner.transfer(amountDue);

        emit ACarTurnedIn(carIndex, amountDue);
    }
}