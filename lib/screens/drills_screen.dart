import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrillsScreen extends StatelessWidget {
  const DrillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset("assets/images/icons/solo_drills.png", width: 30),

            const SizedBox(width: 10),

            Text(
              "Solo Drills",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //================ AI CARD =================
            Container(
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: const LinearGradient(
                  colors: [Color(0xff34d46a), Color(0xff1aa39d)],
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "⭐ AI Recommended",

                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Today's Drill",

                    style: GoogleFonts.poppins(
                      color: Colors.white,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Shadow Footwork",

                    style: GoogleFonts.poppins(
                      color: Colors.white,

                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "20 Minutes • Intermediate",

                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: Text(
                        "START NOW",

                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            //================ CATEGORIES =================
            Text(
              "Drill Categories",

              style: GoogleFonts.poppins(
                color: Colors.white,

                fontWeight: FontWeight.bold,

                fontSize: 24,
              ),
            ),

            const SizedBox(height: 18),

            GridView.count(
              crossAxisCount: 2,

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              mainAxisSpacing: 16,

              crossAxisSpacing: 16,

              childAspectRatio: 0.62,

              children: [
                categoryCard("👣", "Shadow Movement", "Movement & Recovery","14 Drills"),

                categoryCard("🎯", "Serve Practice", "High • Low • Flick","18 Drills"),

                categoryCard("🏸", "Stroke Practice", "Clear • Drop • Smash","15 Drills"),

                categoryCard("🛡", "Attack & Defense", "Net • Lift • Defence","10 Drills"),

                categoryCard("🧱", "Wall Training", "Reaction Practice","30 Drills"),

                categoryCard("💪", "Fitness", "Agility & Strength","20 Drills"),
              ],
            ),

            const SizedBox(height: 35),

            //================ FAVORITES =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "Favorite Drills",

                  style: GoogleFonts.poppins(
                    color: Colors.white,

                    fontSize: 24,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(onPressed: () {}, child: const Text("See All")),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 170,

              child: ListView(
                scrollDirection: Axis.horizontal,

                children: [
                  favoriteCard("🏸", "Smash Repetition"),

                  favoriteCard("👣", "Six Corner"),

                  favoriteCard("🧱", "Wall Drives"),
                ],
              ),
            ),

            const SizedBox(height: 35),

            //================ DAILY CHALLENGE =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2433),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.casino_rounded,
                        color: Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Daily Challenge",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "150 Shadow Footwork Steps",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Reward: +50 XP",
                    style: GoogleFonts.poppins(
                      color: Colors.greenAccent,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "START CHALLENGE",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            //================ TRAINING STATS =================
            Text(
              "Training Stats",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 18),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35,
              children: [
                statCard(Icons.timer, "28 hrs", "Total Time"),

                statCard(
                  Icons.local_fire_department,
                  "12 Days",
                  "Current Streak",
                ),

                statCard(Icons.check_circle, "74", "Completed"),

                statCard(Icons.favorite, "Smash", "Favorite Drill"),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

//================ CATEGORY CARD =================

Widget categoryCard(
  String emoji,
  String title,
  String subtitle,
  String drills,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2433),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .20),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Emoji
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  drills,
                  style: GoogleFonts.poppins(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  //================ FAVORITE CARD =================

  Widget favoriteCard(String emoji, String title) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2433),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green.withValues(alpha: .18),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),

          const Spacer(),

          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Favorite Drill",
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //================ STATS CARD =================

  Widget statCard(IconData icon, String value, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2433),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 30),

          const SizedBox(height: 10),

          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
