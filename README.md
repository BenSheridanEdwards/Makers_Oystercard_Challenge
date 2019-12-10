
### [Makers Academy](http://www.makersacademy.com) - Week 2 Pair Programming Project

Oystercard Ruby Challenge
-

[Outline](#Outline) | [Task](#Task) | [Goals](#Goals) | [Installation Instructions](#Installation) | [User Stories](#Story) | [Objects & Methods](#Methods) | [Feature Tests](#Feature_Tests) |

## <a name="Outline">Outline</a>

Build London's Oystercard system in Ruby!

## <a name="Task">The Task</a>

This week's challenge will start with going back over the basics I covered last week in Boris Bikes, giving me the chance to reinforce what I learned last week. I'll then be challenged to build a more complex system which should really stretch my skills in Ruby, TDD and object-oriented design.

## <a name="Goals">Goals</a>

### I write code that is easy to change

Writing easy to change software is highly prized amongst developers and employers. By developers because most of a developer's time is spent changing software. By employers because their teams can deliver value to customers faster.

### I can test-drive my code

Tested software is easier to change because you can tell when it's broken just by running a command, even the tricky edge cases.

### I can build with objects
Most code in the world is structured in small pieces called objects. This is done because it is easier to change than having everything in one place.

## <a name="Installation">Installation Instructions</a>

## <a name="Story">User Stories</a>

```
In order to use public transport
As a customer
I want money on my card

In order to keep using public transport
As a customer
I want to add money to my card

In order to protect my money
As a customer
I don't want to put too much money on my card

In order to pay for my journey
As a customer
I need my fare deducted from my card

In order to get through the barriers
As a customer
I need to touch in and out

In order to pay for my journey
As a customer
I need to have the minimum amount for a single journey

In order to pay for my journey
As a customer
I need to pay for my journey when it's complete

In order to pay for my journey
As a customer
I need to know where I've travelled from

In order to know where I have been
As a customer
I want to see to all my previous trips

In order to know how far I have travelled
As a customer
I want to know what zone a station is in

In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out

In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```

<a name="Methods">Objects & Methods</a>

### OysterCard

| Methods | Description |
| --- | --- |
| OysterCard.new     | Creates a new instance of Oyster Card                                                                |
| .top_up(amount)    | Allows the user to top up their balance by a given amount                                            |
| .touch_in(station) | Creates a new instance of journey and stores the station as an attribute of journey within the journey log |
| .touch_out(station)| Adds the finish station attribute to the current instance of journey and deduces the fare            |
| .journey_history   | Displays a copy of the journey log|


### Journey Log

| Methods | Description |
| --- | --- |
| JourneyLog.new | Creates a new instance of Journey Log |
| .in_journey? | Returns true if the last instance of journey in the journey log has a start station and no finish station | 
| .start(station) | Called by the 'touch_in' method on the OysterCard class. It initializes an instance of Journey and passes the station argument to it. It also sets in_journey to true. |
|.finish(station) | Called by the 'touch_out' method on the OysterCard class. It passes the station to the last journey instance in the journey log. Also switches in_journey to false |
| .journeys | Creates a copy of the current Journey Log and outputs it to the user |


### Journey

| Methods | Description |
| --- | --- |
| .start(station) | Sets the station as the @entry_station attribute of the journey instance & sets in_journey to true.
| .finish(station) | Sets the station as the @exit_station attribute of the journey instance & sets in_journey to false.
| .fare | Calulates the fare based on the minimum fare, zones traveled, and if a penalty has been issued for a previous journey |


## <a name="Feature Test">Feature Tests</a>

To be added...
