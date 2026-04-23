class RecommendationEngine {
  // --- FOOD RECOMMENDATIONS ---
  static List<Map<String, dynamic>> getFoodRecommendations(
      String condition, double temp) {
    final c = condition.toLowerCase();

    if (temp >= 38 || c.contains('hot')) {
      return [
        {'icon': '🍉', 'name': 'Watermelon', 'reason': 'High water content, cools body'},
        {'icon': '🥒', 'name': 'Cucumber', 'reason': '96% water, refreshing & light'},
        {'icon': '🍋', 'name': 'Lemon Juice', 'reason': 'Electrolytes & Vitamin C'},
        {'icon': '🥗', 'name': 'Green Salad', 'reason': 'Light, hydrating & nutritious'},
        {'icon': '🍇', 'name': 'Grapes', 'reason': 'Antioxidants & cooling properties'},
        {'icon': '🥤', 'name': 'Coconut Water', 'reason': 'Natural electrolytes & hydration'},
        {'icon': '🍊', 'name': 'Citrus Fruits', 'reason': 'Vitamins, refresh & energize'},
        {'icon': '🌿', 'name': 'Mint Chutney', 'reason': 'Natural cooling agent'},
      ];
    } else if (c.contains('rain') || c.contains('cloud')) {
      return [
        {'icon': '🍜', 'name': 'Hot Soup', 'reason': 'Warming & immune boosting'},
        {'icon': '🥔', 'name': 'Potato Dishes', 'reason': 'Comfort food, energy-rich'},
        {'icon': '🫚', 'name': 'Ginger Tea', 'reason': 'Anti-inflammatory, warming'},
        {'icon': '🌽', 'name': 'Corn on Cob', 'reason': 'Classic rainy day snack'},
        {'icon': '🍵', 'name': 'Masala Chai', 'reason': 'Aromatic spices boost immunity'},
        {'icon': '🥜', 'name': 'Roasted Nuts', 'reason': 'Warm, energizing protein snack'},
        {'icon': '🫚', 'name': 'Turmeric Milk', 'reason': 'Anti-bacterial, warming'},
        {'icon': '🥘', 'name': 'Lentil Dal', 'reason': 'Protein-rich comfort food'},
      ];
    } else if (temp <= 10 || c.contains('snow')) {
      return [
        {'icon': '🍲', 'name': 'Hot Stew', 'reason': 'Warming & filling in cold'},
        {'icon': '☕', 'name': 'Hot Chocolate', 'reason': 'Mood booster & warming'},
        {'icon': '🥣', 'name': 'Oatmeal', 'reason': 'High energy, keeps you warm'},
        {'icon': '🧅', 'name': 'Onion Soup', 'reason': 'Classic winter warmer'},
        {'icon': '🍠', 'name': 'Sweet Potato', 'reason': 'Beta-carotene & warmth'},
        {'icon': '🍵', 'name': 'Herbal Tea', 'reason': 'Warming & calming blend'},
        {'icon': '🥩', 'name': 'Protein Foods', 'reason': 'Keeps body warm via metabolism'},
        {'icon': '🌰', 'name': 'Chestnuts', 'reason': 'Traditional winter snack'},
      ];
    } else {
      // Moderate / pleasant weather
      return [
        {'icon': '🥗', 'name': 'Mixed Salad', 'reason': 'Fresh, light & energizing'},
        {'icon': '🍓', 'name': 'Seasonal Fruits', 'reason': 'Vitamins & natural sugars'},
        {'icon': '🥑', 'name': 'Avocado Toast', 'reason': 'Healthy fats & sustained energy'},
        {'icon': '🫐', 'name': 'Blueberries', 'reason': 'Antioxidants & brain health'},
        {'icon': '🥤', 'name': 'Smoothie', 'reason': 'Blend of nutrients & hydration'},
        {'icon': '🌮', 'name': 'Veggie Wrap', 'reason': 'Balanced & easy to digest'},
        {'icon': '🍊', 'name': 'Orange Juice', 'reason': 'Fresh Vitamin C boost'},
        {'icon': '🥜', 'name': 'Trail Mix', 'reason': 'Energy on the go'},
      ];
    }
  }

  // --- CLOTHING RECOMMENDATIONS ---
  static List<Map<String, dynamic>> getClothingRecommendations(
      String condition, double temp) {
    final c = condition.toLowerCase();

    if (c.contains('rain') || c.contains('drizzle')) {
      return [
        {'icon': '🧥', 'name': 'Raincoat / Windbreaker', 'detail': 'Waterproof outer layer'},
        {'icon': '☂️', 'name': 'Umbrella', 'detail': 'Essential rain accessory'},
        {'icon': '👢', 'name': 'Waterproof Boots', 'detail': 'Protect feet from puddles'},
        {'icon': '👕', 'name': 'Quick-dry Fabrics', 'detail': 'Polyester blends dry fast'},
        {'icon': '🧣', 'name': 'Light Scarf', 'detail': 'Prevents chill from rain breeze'},
      ];
    } else if (temp >= 38) {
      return [
        {'icon': '👕', 'name': 'White/Light Cotton', 'detail': 'Reflects heat, breathable'},
        {'icon': '🩳', 'name': 'Loose Shorts', 'detail': 'Airflow & comfort in extreme heat'},
        {'icon': '🧢', 'name': 'Wide Brim Hat', 'detail': 'Essential sun protection'},
        {'icon': '🕶️', 'name': 'UV Sunglasses', 'detail': 'Protect eyes from UV rays'},
        {'icon': '👡', 'name': 'Open Sandals', 'detail': 'Let feet breathe & cool down'},
      ];
    } else if (temp >= 28) {
      return [
        {'icon': '👕', 'name': 'Linen Shirts', 'detail': 'Natural, breathable fabric'},
        {'icon': '🩴', 'name': 'Light Footwear', 'detail': 'Sandals or canvas shoes'},
        {'icon': '🩱', 'name': 'Cotton Dress/Tshirt', 'detail': 'Loose & airy styles'},
        {'icon': '🧢', 'name': 'Cap / Visor', 'detail': 'Shield face from sun'},
        {'icon': '🕶️', 'name': 'Sunglasses', 'detail': 'UV protection is a must'},
      ];
    } else if (temp <= 10 || c.contains('snow')) {
      return [
        {'icon': '🧥', 'name': 'Heavy Woolen Jacket', 'detail': 'Insulation from cold'},
        {'icon': '🧣', 'name': 'Thick Scarf & Muffler', 'detail': 'Neck & chest warmth'},
        {'icon': '🧤', 'name': 'Gloves', 'detail': 'Protect hands from frostbite'},
        {'icon': '🎩', 'name': 'Woolen Beanie', 'detail': 'Retain heat via head'},
        {'icon': '🥾', 'name': 'Insulated Boots', 'detail': 'Waterproof & warm feet'},
      ];
    } else if (temp <= 20) {
      return [
        {'icon': '🧥', 'name': 'Light Jacket', 'detail': 'Layer up for cool breeze'},
        {'icon': '👖', 'name': 'Full Pants / Jeans', 'detail': 'Denim provides warmth'},
        {'icon': '👟', 'name': 'Closed Sneakers', 'detail': 'Comfortable & warm'},
        {'icon': '🧣', 'name': 'Light Scarf', 'detail': 'Optional neck warmth'},
        {'icon': '👕', 'name': 'Layered T-shirts', 'detail': 'Layering regulates temp'},
      ];
    } else {
      return [
        {'icon': '👕', 'name': 'Breathable T-shirt', 'detail': 'Cotton or moisture-wicking'},
        {'icon': '👖', 'name': 'Casual Pants', 'detail': 'Comfortable everyday wear'},
        {'icon': '👟', 'name': 'Comfortable Sneakers', 'detail': 'Great for any activity'},
        {'icon': '🧥', 'name': 'Light Cardigan', 'detail': 'For AC environments'},
        {'icon': '🕶️', 'name': 'Sunglasses', 'detail': 'For outdoor UV protection'},
      ];
    }
  }

  // --- COLOR RECOMMENDATIONS ---
  static List<Map<String, dynamic>> getColorRecommendations(
      String condition, double temp) {
    final c = condition.toLowerCase();

    if (c.contains('rain') || c.contains('cloud')) {
      return [
        {'color': 0xFF5B8DB8, 'name': 'Steel Blue', 'mood': 'Calm & grounded'},
        {'color': 0xFF8B9BB4, 'name': 'Slate Grey', 'mood': 'Sophisticated & neutral'},
        {'color': 0xFFB8A9C9, 'name': 'Lavender', 'mood': 'Gentle & soothing'},
        {'color': 0xFF6B7F6B, 'name': 'Sage Green', 'mood': 'Earthy & refreshing'},
        {'color': 0xFFD4C5B2, 'name': 'Warm Beige', 'mood': 'Cozy & comforting'},
      ];
    } else if (temp >= 35) {
      return [
        {'color': 0xFFFFFFFF, 'name': 'Pure White', 'mood': 'Reflects heat & clean'},
        {'color': 0xFFFFF9E6, 'name': 'Ivory Cream', 'mood': 'Light & elegant'},
        {'color': 0xFF87CEEB, 'name': 'Sky Blue', 'mood': 'Cool & refreshing'},
        {'color': 0xFFFFB347, 'name': 'Peach Orange', 'mood': 'Energetic & vibrant'},
        {'color': 0xFFF0E68C, 'name': 'Khaki Yellow', 'mood': 'Cheerful & sunny'},
      ];
    } else if (temp <= 10) {
      return [
        {'color': 0xFF8B0000, 'name': 'Deep Burgundy', 'mood': 'Warm & bold'},
        {'color': 0xFF556B2F, 'name': 'Forest Green', 'mood': 'Grounded & natural'},
        {'color': 0xFF4B0082, 'name': 'Indigo', 'mood': 'Deep & mysterious'},
        {'color': 0xFF800020, 'name': 'Crimson', 'mood': 'Rich & warming'},
        {'color': 0xFFC0A882, 'name': 'Camel Brown', 'mood': 'Earthy & classic'},
      ];
    } else {
      return [
        {'color': 0xFF98FB98, 'name': 'Mint Green', 'mood': 'Fresh & lively'},
        {'color': 0xFFFFB6C1, 'name': 'Soft Pink', 'mood': 'Cheerful & playful'},
        {'color': 0xFFADD8E6, 'name': 'Light Blue', 'mood': 'Calm & pleasant'},
        {'color': 0xFFFFFACD, 'name': 'Lemon Yellow', 'mood': 'Happy & bright'},
        {'color': 0xFFFFC0CB, 'name': 'Pastel Rose', 'mood': 'Romantic & gentle'},
      ];
    }
  }

  // --- WATER INTAKE CALCULATION ---
  static double calculateWaterIntake(double temp, double weightKg) {
    // Base: 35ml per kg body weight
    double base = weightKg * 35;

    // Add extra for heat
    if (temp >= 38) {
      base += 1000; // +1L for heatwave
    } else if (temp >= 32) {
      base += 600; // +600ml for hot
    } else if (temp >= 25) {
      base += 300; // +300ml for warm
    } else if (temp <= 10) {
      base -= 200; // Slightly less for cold
    }

    return base.clamp(1500, 5000); // Between 1.5L and 5L
  }

  // --- HYDRATION RECIPES ---
  static List<Map<String, dynamic>> getHydrationRecipes(double temp) {
    if (temp >= 35) {
      return [
        {
          'name': 'Cucumber Mint Water',
          'emoji': '🥒',
          'temp': 'Best for: Hot Days',
          'ingredients': '3 cucumber slices, 5 mint leaves, 500ml water',
          'steps':
              '1. Slice cucumber thinly\n2. Crush mint leaves lightly\n3. Add to chilled water\n4. Refrigerate 30 min\n5. Serve cold with ice',
          'benefit': 'Cools body, aids digestion & refreshes instantly',
        },
        {
          'name': 'Watermelon Cooler',
          'emoji': '🍉',
          'temp': 'Best for: Very Hot Days',
          'ingredients': '2 cups watermelon, 1 lime, 500ml water, pinch salt',
          'steps':
              '1. Blend watermelon chunks\n2. Add lime juice & salt\n3. Strain and mix with cold water\n4. Add ice & serve fresh',
          'benefit': 'Extreme hydration, natural electrolytes & cooling',
        },
        {
          'name': 'Lemon Mint Iced Water',
          'emoji': '🍋',
          'temp': 'Best for: Hot & Humid',
          'ingredients': '1 lemon, 8 mint leaves, 1 tsp honey, 500ml water',
          'steps':
              '1. Squeeze lemon juice\n2. Tear mint leaves\n3. Dissolve honey in warm water\n4. Mix all & chill\n5. Serve over ice',
          'benefit': 'Vitamin C boost, metabolism aid & hydration',
        },
      ];
    } else if (temp >= 20) {
      return [
        {
          'name': 'Lemon Honey Water',
          'emoji': '🍯',
          'temp': 'Best for: Moderate Days',
          'ingredients': '1 lemon, 1 tbsp raw honey, 400ml water',
          'steps':
              '1. Warm water slightly\n2. Dissolve honey\n3. Add fresh lemon juice\n4. Stir well & enjoy',
          'benefit': 'Immune boost, energy & gentle detox',
        },
        {
          'name': 'Coconut Water Refresh',
          'emoji': '🥥',
          'temp': 'Best for: Warm Days',
          'ingredients': '300ml coconut water, 100ml water, lime wedge',
          'steps':
              '1. Pour fresh coconut water\n2. Add splash of water\n3. Squeeze lime\n4. Stir & serve chilled',
          'benefit': 'Natural electrolytes, potassium & perfect hydration',
        },
        {
          'name': 'Strawberry Basil Water',
          'emoji': '🍓',
          'temp': 'Best for: Pleasant Weather',
          'ingredients': '4 strawberries, 4 basil leaves, 500ml water',
          'steps':
              '1. Slice strawberries\n2. Tear basil leaves\n3. Combine in pitcher\n4. Add water & refrigerate 1 hour',
          'benefit': 'Antioxidants, anti-inflammatory & delicious taste',
        },
      ];
    } else {
      return [
        {
          'name': 'Warm Lemon Ginger Water',
          'emoji': '🫚',
          'temp': 'Best for: Cold Days',
          'ingredients': '1 lemon, 1 inch ginger, 400ml hot water, honey',
          'steps':
              '1. Boil water\n2. Grate fresh ginger\n3. Steep 5 min\n4. Strain & add lemon juice\n5. Sweeten with honey',
          'benefit': 'Warming, anti-inflammatory & immune boosting',
        },
        {
          'name': 'Herbal Cinnamon Infusion',
          'emoji': '🫖',
          'temp': 'Best for: Cold & Rainy',
          'ingredients': '1 cinnamon stick, 3 cloves, 400ml hot water',
          'steps':
              '1. Boil water with cinnamon stick\n2. Add cloves\n3. Simmer 5 min\n4. Strain & serve hot',
          'benefit': 'Blood sugar regulation, warming & aromatic',
        },
        {
          'name': 'Turmeric Golden Water',
          'emoji': '💛',
          'temp': 'Best for: Cold & Cloudy',
          'ingredients': '½ tsp turmeric, black pepper, 400ml warm water, honey',
          'steps':
              '1. Warm water (not boiling)\n2. Stir in turmeric & pepper\n3. Add honey to taste\n4. Drink while warm',
          'benefit': 'Anti-inflammatory, immunity booster & healing',
        },
      ];
    }
  }
}