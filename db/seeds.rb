services = [
    { name: "Pet Hosting", description: "Overnight stays and pet care in your home" },
    { name: "Pet Sitting", description: "Overnight care at the pet-owner home"},
    { name: "House Visiting", description: "Drop in visits"},
    { name: "Dog Walking", description: "Fun and active walks for your dog"},
    { name: "Pet Grooming", description: "Washing, brushing & combing, coat clipping, nail cutting and other grooming services"}
]

# Feeding SERVICE table with the STATIC services offered by a potential PETSITTER 
Service.create(services)

# Creating 20 random Users with made up information (through Faker)
for i in 1..30
    first_name = Faker::Name.first_name
    user = User.create(
        email: Faker::Internet.email(name: first_name),
        password: "test1234",
        first_name: first_name,
        last_name: Faker::Name.last_name,
        dob: Faker::Date.birthday(min_age: 18, max_age: 65)
    )

    puts "Created USER #{first_name}"

end


# Out of the previous 30 USERS, 15 of them are randomly converted into PETSITTERS
random_petsitter_ids = User.pluck(:id).sample(15)
# Remaining USERS who are PETOWNERS
random_petowner_ids = User.pluck(:id) - random_petsitter_ids

puts "random_petsitter_ids = #{random_petsitter_ids}"
puts "random_petowner_ids = #{random_petowner_ids}"


for id in random_petsitter_ids

    # Creating PETSITTERS
    petsitter = Petsitter.create(
        user_id: id,
        price_rate: rand(20..50) * 100,
        status: 0 # Active
    )

    puts "Created PETSITTER #{petsitter.user.first_name}"

    # Each PETSITTER offers from 1 to 3 SERVICES
    service_ids = []
    for i in 1..3
        service_ids.push Service.pluck(:id).sample
        service_ids.uniq!
    end

    # PETSITTERS_SERVICES table popolated
    services = Service.where(id: service_ids)
    petsitter.services = services
    puts "Petsitter #{petsitter.user.first_name} offers services of #{service_ids}"

end

pet_types = {
    "small dog":  0,
    "medium dog": 1,
    "large dog":  2,
    "giant dog":  3,
    "puppy":      4,
    "cat":        5,
    "rabbit":     6
}


for user_id in random_petowner_ids

    # Creating a pet for each PETOWNER
    p = Pet.create(
        name: Faker::Creature::Cat.name,
        pet_type: pet_types[pet_types.keys.sample],
        user_id: user_id
    )

    # Creating a booking for each PETOWNER
    b = Booking.create(
        user_id: user_id,
        petsitter_id: User.find(random_petsitter_ids.pop).petsitter.id,
        from_date: Faker::Date.backward(days: 30),
        to_date: Faker::Date.forward(days: 30),
        status: 1 # accepted
    )

    p.bookings = [b]

end

# 3 Random BOOKINGS are marked as payed and inserted into the TRANSACTIONS table
for booking in Booking.all.sample(3)

    booking.status = 3 # payed
    booking.save
 
    amount = (booking.petsitter.price_rate * (booking.to_date - booking.from_date).to_i)

    p = Payment.create(
        booking_id: booking.id,
        amount: amount
    )

    puts "Payment inserted: $#{amount}"

end