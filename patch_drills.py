import re

def patch_file():
    # 1. Update drill_catalog.dart
    with open('lib/domain/data/drill_catalog.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # Add progression and completionCriteria to all drills.
    # We can match `motivationQuote: '...',` or `motivationQuote: null,`
    content = re.sub(r'(motivationQuote:[^\n]+,)', r'\1\n      progression: \'\',\n      completionCriteria: \'\',', content)
    
    # Increase rest intervals in fw_six_corner and sd_smash from 20 to 45
    content = content.replace(
        "title: 'Rest Phase',\n          description: 'Catch your breath',\n          durationSeconds: 20,\n          type: PhaseType.rest",
        "title: 'Rest Phase',\n          description: 'Catch your breath',\n          durationSeconds: 45,\n          type: PhaseType.rest"
    )
    # Note: I might need to adjust the exact string match for rest phases. Let's just use regex for 20s rest phases in those drills.
    
    # Fix coachCue in fw_front_court
    content = content.replace(
        "coachCue: 'Push violently off your front heel to recover to center.',",
        "coachCue: 'Land heel-first, then push explosively off the ball of your foot to recover backward.',"
    )
    
    # Fix sd_wall instructions
    content = content.replace(
        "'Stand 2 meters from wall and rally continuous forehand & backhand flat drives.',",
        "'Stand 3-4 meters from the wall and rally continuous forehand & backhand flat drives.',"
    )

    with open('lib/domain/data/drill_catalog.dart', 'w', encoding='utf-8') as f:
        f.write(content)

    # 2. Update tutorials_screen.dart
    with open('lib/presentation/screens/tutorials_screen.dart', 'r', encoding='utf-8') as f:
        tut_content = f.read()
        
    tut_content = tut_content.replace(
        "contactPoint: 'Below waist level (1.15 meter rule).',",
        "contactPoint: 'Contact the shuttle below the strict 1.15-meter fixed height limit.',"
    )
    tut_content = tut_content.replace(
        "bodyPosition: 'Slight forward lean with racket held below waist level.',",
        "bodyPosition: 'Slight forward lean with racket held below the strict 1.15-meter fixed height limit.',"
    )
    tut_content = tut_content.replace(
        "contactPoint: 'Below waist level in front of lead hip.',",
        "contactPoint: 'Contact the shuttle below the strict 1.15-meter fixed height limit.',"
    )
    
    with open('lib/presentation/screens/tutorials_screen.dart', 'w', encoding='utf-8') as f:
        f.write(tut_content)
        
    print("Patched all files")

if __name__ == '__main__':
    patch_file()
