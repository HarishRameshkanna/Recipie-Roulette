import SwiftUI

struct HomeView: View {
    @State private var name: String = "" // State variable to store the person's name
    @State private var selectedCuisine: Cuisine = .all
    @State private var selectedCalories: Int = 0
    @State private var selectedDietaryRestrictions: DietaryRestriction = .none
    @State private var selectedAllergies: Allergy = .none
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Welcome to Recepie Roulette")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 4)
                    )
                
                Spacer()
                
                Stepper(value: $selectedCalories, in: 0...5000, step: 100) {
                    Text("Calories: \(selectedCalories) kcal")
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Cuisine")
                        .font(.headline)
                    Picker("Cuisine", selection: $selectedCuisine) {
                        ForEach(Cuisine.allCases, id: \.self) { cuisine in
                            Text(cuisine.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                
                VStack(alignment: .leading) {
                    Text("Dietary Restrictions")
                        .font(.headline)
                    Picker("Dietary Restrictions", selection: $selectedDietaryRestrictions) {
                            ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                                Text(restriction.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                
                VStack(alignment: .leading) {
                    Text("Allergies")
                        .font(.headline)
                    Picker("Allergies", selection: $selectedAllergies) {
                            ForEach(Allergy.allCases, id: \.self) { allergy in
                                Text(allergy.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }

                 
              
                
                NavigationLink(destination: RecipeListView(name: name,
                    selectedCuisine: selectedCuisine, selectedCalories:
                    selectedCalories, selectedDietaryRestrictions:
                    selectedDietaryRestrictions, selectedAllergies: selectedAllergies)) {
                                    Text("Start Cooking!")
                                        .font(.headline)
                                        .padding()
                }
                
                
                 
            }
            
        }
    }
}
struct RecipeListView: View {
    let name: String // The person's name
    let selectedCuisine: Cuisine
    let selectedCalories: Int
    let selectedDietaryRestrictions: DietaryRestriction
    let selectedAllergies: Allergy
    @State private var randomRecipes: [Recipe] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Here are Your Options, \(name)!")
                    .font(.title)
                    .padding()
                
                List(randomRecipes) { recipe in
                    NavigationLink(destination: RecipeImageView(recipe: recipe)) {
                        Text(recipe.name)
                    }
                }
                
                Button(action: {
                    fetchRandomRecipes()
                }) {
                    Text("Find Recipes")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationBarTitle("Recipe List")
            .onAppear {
                fetchRandomRecipes()
            }
        }
    }

 
    
    func fetchRandomRecipes() {
            // Filter recipes based on selected criteria
            var filteredRecipes = RecipeDatabase.recipes
            
            if selectedCuisine != .all {
                filteredRecipes = filteredRecipes.filter { $0.cuisine == selectedCuisine }
            }
            
            if selectedCalories > 0 {
                filteredRecipes = filteredRecipes.filter { $0.calories <= selectedCalories }
            }
        if selectedDietaryRestrictions != .none {
                    filteredRecipes = filteredRecipes.filter { $0.dietaryRestrictions.contains(selectedDietaryRestrictions) }
                }
        if selectedAllergies != .none {
            filteredRecipes = filteredRecipes.filter { !$0.allergies.contains(selectedAllergies)}
        }

//            if !selectedDietaryRestrictions.isEmpty {
//                filteredRecipes = filteredRecipes.filter { recipe in
//                    selectedDietaryRestrictions.allSatisfy { restriction in
//                        recipe.dietaryRestrictions.contains(restriction)
//                    }
  //              }
    //        }
            
//            if !selectedAllergies.isEmpty {
  //              filteredRecipes = filteredRecipes.filter { recipe in
    //                selectedAllergies.allSatisfy { allergy in
      //                  !recipe.allergies.contains(allergy)
        //            }
          //      }
            //}
            
            // Shuffle the filtered recipes and select the first 10
            randomRecipes = Array(filteredRecipes.shuffled().prefix(5))
        }
    }
struct RecipeImageView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Image(recipe.imageName)
                
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 500)
                .padding()
            
            Spacer()
        }
        .navigationTitle(recipe.name)
    }
}

struct Recipe: Identifiable {
    var id = UUID()
    
    let name: String
    let cuisine: Cuisine
    let calories: Int
    let dietaryRestrictions: [DietaryRestriction]
    let allergies: [Allergy]
    let imageName: String
}
struct RecipeDatabase {
    static let recipes: [Recipe] = [
        Recipe(name: "Spaghetti Carbonara", cuisine: .italian, calories: 500, dietaryRestrictions: [.none], allergies: [.none], imageName: "Spaghetti_Carbonara"),
        Recipe(name: "Chicken Tikka Masala", cuisine: .indian, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName: "chicken_tikka_masala"),
        Recipe(name: "Tacos al Pastor", cuisine: .mexican, calories: 550, dietaryRestrictions: [.none], allergies: [.none], imageName: "tacos_al_pastor"),
        Recipe(name: "General Tso's Chicken", cuisine: .chinese, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"general_tso's_chicken"),
        Recipe(name: "Sushi Rolls", cuisine: .japanese, calories: 400, dietaryRestrictions: [.none], allergies: [.none],imageName:"sushi_rolls"),
        Recipe(name: "Coq au Vin", cuisine: .french, calories: 750, dietaryRestrictions: [.none], allergies: [.none],imageName:"coq_au_vin"),
        Recipe(name: "Pad Thai", cuisine: .thai, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"pad_thai"),
        Recipe(name: "Margherita Pizza", cuisine: .italian, calories: 700, dietaryRestrictions: [.none], allergies: [.dairy],imageName:"margherita_pizza"),
        Recipe(name: "Guacamole", cuisine: .mexican, calories: 200, dietaryRestrictions: [.none], allergies: [.none],imageName:"guacamole"),
        Recipe(name: "Butter Chicken", cuisine: .indian, calories: 650, dietaryRestrictions: [.none], allergies: [.none],imageName:"butter_chicken"),
        Recipe(name: "Beef Bourguignon", cuisine: .french, calories: 800, dietaryRestrictions: [.none], allergies: [.none],imageName:"beef_bourguignon"),
        Recipe(name: "Tom Yum Soup", cuisine: .thai, calories: 300, dietaryRestrictions: [.none], allergies: [.shellfish],imageName:"tom_yum_soup"),
        Recipe(name: "Enchiladas", cuisine: .mexican, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"enchiladas"),
        Recipe(name: "Peking Duck", cuisine: .chinese, calories: 900, dietaryRestrictions: [.none], allergies: [.none],imageName:"peking_duck"),
        Recipe(name: "Ratatouille", cuisine: .french, calories: 450, dietaryRestrictions: [.vegan], allergies: [.none],imageName:"ratatouille"),
        Recipe(name: "Salmon Teriyaki", cuisine: .japanese, calories: 550, dietaryRestrictions: [.none], allergies: [.fish],imageName:"salmon_teriyaki"),
        Recipe(name: "Caprese Salad", cuisine: .italian, calories: 300, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"caprese_salad"),
        Recipe(name: "Vegetable Stir Fry", cuisine: .chinese, calories: 400, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"vegetable_stir_fry"),
        Recipe(name: "Miso Soup", cuisine: .japanese, calories: 150, dietaryRestrictions: [.vegan], allergies: [.none],imageName:"miso_soup"),
        Recipe(name: "Cheese Quesadilla", cuisine: .mexican, calories: 400, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"cheese_quesadilla"),
        Recipe(name: "Paneer Tikka", cuisine: .indian, calories: 500, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"paneer_tikka"),
        Recipe(name: "Crepes", cuisine: .french, calories: 350, dietaryRestrictions: [.none], allergies: [.none],imageName:"crepes"),
        Recipe(name: "California Roll", cuisine: .japanese, calories: 500, dietaryRestrictions: [.none], allergies: [.shellfish],imageName:"california_roll"),
        Recipe(name: "Egg Drop Soup", cuisine: .chinese, calories: 200, dietaryRestrictions: [.none], allergies: [.none],imageName:"egg_drop_soup"),
        Recipe(name: "Chicken Parmesan", cuisine: .italian, calories: 800, dietaryRestrictions: [.none], allergies: [.none],imageName:"chicken_parmesan"),
        Recipe(name: "Vegetable Curry", cuisine: .indian, calories: 600, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"vegetable_curry"),
        Recipe(name: "Chicken Enchiladas", cuisine: .mexican, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"chicken_enchiladas"),
        Recipe(name: "Beef Chow Mein", cuisine: .chinese, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"beef_chow_mein"),
        Recipe(name: "Sushi Sashimi", cuisine: .japanese, calories: 650, dietaryRestrictions: [.none], allergies: [.none],imageName:"sushi_sashimi"),
        Recipe(name: "Pho", cuisine: .thai, calories: 500, dietaryRestrictions: [.none], allergies: [.none],imageName:"pho"),
        Recipe(name: "Tiramisu", cuisine: .italian, calories: 400, dietaryRestrictions: [.none], allergies: [.none],imageName:"tiramisu"),
        Recipe(name: "Beef Tacos", cuisine: .mexican, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"beef_tacos"),
        Recipe(name: "Kung Pao Tofu", cuisine: .chinese, calories: 500, dietaryRestrictions: [.vegetarian], allergies: [.peanuts],imageName:"kung_pao_tofo"),
        Recipe(name: "Veggie Sushi Rolls", cuisine: .japanese, calories: 350, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"veggie_sushi_rolls"),
        Recipe(name: "Crepes Suzette", cuisine: .french, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"crepes_suzette"),
        Recipe(name: "Lasagna", cuisine: .italian, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"lasagna"),
        Recipe(name: "Chile Relleno", cuisine: .mexican, calories: 550, dietaryRestrictions: [.none], allergies: [.none],imageName:"chile_relleno"),
        Recipe(name: "Orange Chicken", cuisine: .chinese, calories: 750, dietaryRestrictions: [.none], allergies: [.none],imageName:"orange_chicken"),
        Recipe(name: "Soba Noodles", cuisine: .japanese, calories: 400, dietaryRestrictions: [.none], allergies: [.none],imageName:"soba_noodles"),
        Recipe(name: "Escargot", cuisine: .french, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"escargot"),
        Recipe(name: "Spaghetti Bolognese", cuisine: .italian, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"spaghetti_bolognese"),
        Recipe(name: "Nachos", cuisine: .mexican, calories: 800, dietaryRestrictions: [.none], allergies: [.none],imageName:"nachos"),
        Recipe(name: "Beef and Broccoli", cuisine: .chinese, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"beef_and_broccoli"),
        Recipe(name: "Tempura", cuisine: .japanese, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"tempura"),
        Recipe(name: "Onion Soup", cuisine: .french, calories: 300, dietaryRestrictions: [.none], allergies: [.none],imageName:"onion_soup"),
        Recipe(name: "Fettuccine Alfredo", cuisine: .italian, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"fettuccine_alfredo"),
        Recipe(name: "Taco Salad", cuisine: .mexican, calories: 500, dietaryRestrictions: [.none], allergies: [.none],imageName:"taco_salad"),
        Recipe(name: "Kung Pao Chicken", cuisine: .chinese, calories: 700, dietaryRestrictions: [.none], allergies: [.peanuts],imageName:"kung_pao_chicken"),
        Recipe(name: "Rice Bowl", cuisine: .japanese, calories: 450, dietaryRestrictions: [.none], allergies: [.none],imageName:"rice_bowl"),
        Recipe(name: "Croissant", cuisine: .french, calories: 350, dietaryRestrictions: [.none], allergies: [.none],imageName:"croissant"),
        Recipe(name: "Margherita Pizza", cuisine: .italian, calories: 700, dietaryRestrictions: [.none], allergies: [.dairy],imageName:"margherita_pizza"),
        Recipe(name: "Chimichanga", cuisine: .mexican, calories: 800, dietaryRestrictions: [.none], allergies: [.none],imageName:"chimichanga"),
        Recipe(name: "Spring Rolls", cuisine: .chinese, calories: 400, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"spring_rolls"),
        Recipe(name: "Quiche", cuisine: .french, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"quiche"),
        Recipe(name: "Fettuccine Carbonara", cuisine: .italian, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"fettuccine_carbonara"),
        Recipe(name: "Burrito", cuisine: .mexican, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"burrito"),
        Recipe(name: "Sweet and Sour Chicken", cuisine: .chinese, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"sweet_and_sour_chicken"),
        Recipe(name: "Sushi Platter", cuisine: .japanese, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"sushi_platter"),
        Recipe(name: "French Onion Soup", cuisine: .french, calories: 400, dietaryRestrictions: [.none], allergies: [.none],imageName:"french_onion_soup"),
        Recipe(name: "Fusilli Pasta", cuisine: .italian, calories: 500, dietaryRestrictions: [.none], allergies: [.none],imageName:"fuisili_pasta"),
        Recipe(name: "Tostadas", cuisine: .mexican, calories: 650, dietaryRestrictions: [.none], allergies: [.none],imageName:"tostadas"),
        Recipe(name: "Sweet and Sour Tofu", cuisine: .chinese, calories: 600, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"sweet_and_sour_tofu"),
        Recipe(name: "Sashimi", cuisine: .japanese, calories: 300, dietaryRestrictions: [.none], allergies: [.none],imageName:"sashimi"),
        Recipe(name: "Potato Soup", cuisine: .french, calories: 400, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"potato_soup"),
        Recipe(name: "Caprese Pasta", cuisine: .italian, calories: 600, dietaryRestrictions: [.vegetarian], allergies: [.none],imageName:"caprese_pasta"),
        Recipe(name: "Fajitas", cuisine: .mexican, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"fajitas"),
        Recipe(name: "Mongolian Beef", cuisine: .chinese, calories: 800, dietaryRestrictions: [.none], allergies: [.none],imageName:"mongolian_beef"),
        Recipe(name: "Sushi Burrito", cuisine: .japanese, calories: 700, dietaryRestrictions: [.none], allergies: [.none],imageName:"sushi_burrito"),
        Recipe(name: "Creme Brulee", cuisine: .french, calories: 350, dietaryRestrictions: [.none], allergies: [.none],imageName:"creme_brulee"),
        Recipe(name: "Rigatoni Pasta", cuisine: .italian, calories: 550, dietaryRestrictions: [.none], allergies: [.none],imageName:"rigatoni_pasta"),
        Recipe(name: "Burrito Bowl", cuisine: .mexican, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"burrito_bowl"),
        Recipe(name: "Kung Pao Beef", cuisine: .chinese, calories: 750, dietaryRestrictions: [.none], allergies: [.peanuts],imageName:"kung_pao_beef"),
        Recipe(name: "Yakitori", cuisine: .japanese, calories: 450, dietaryRestrictions: [.none], allergies: [.none],imageName:"yakitori"),
        Recipe(name: "Croque Monsieur", cuisine: .french, calories: 600, dietaryRestrictions: [.none], allergies: [.none],imageName:"croque_monsieur"),
         

    ]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

enum Cuisine: String, CaseIterable {
    case all = "All"
    case italian = "Italian"
    case mexican = "Mexican"
    case indian = "Indian"
    case chinese = "Chinese"
    case japanese = "Japanese"
    case french = "French"
    case thai = "Thai"
}

enum DietaryRestriction: String, CaseIterable {
    case none = "None"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten Free"
}

enum Allergy: String, CaseIterable {
    case none = "None"
    case peanuts = "Peanuts"
    case dairy = "Dairy"
    case shellfish = "Shellfish"
    case soy = "Soy"
    case eggs = "Eggs"
    case fish = "Fish"
    case wheat = "Wheat"
    case treeNuts = "Tree Nuts"
    case sesame = "Sesame"
    case sulfites = "Sulfites"
}
