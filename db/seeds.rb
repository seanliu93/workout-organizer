User.destroy_all
Workout.destroy_all
Exercise.destroy_all
User.create(username: "seanliu", password: "guitarmania")
@workout = Workout.create(name: "Sean's Workout", user_id: User.first.id, active: true)
Exercise.create(name: "Squat", num_sets: 3, num_reps: 8)
Exercise.create(name: "Deadlift", num_sets: 3, num_reps: 8)
Exercise.create(name: "Bench Press", num_sets: 3, num_reps: 8)