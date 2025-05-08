import 'package:flutter/material.dart';

class DataProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // alignement à gauche
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/beauty.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jean Dupont',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Phrase + icône
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Want to edit your profile?',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.edit, color:  Color(0xFF9fbef7)
                      , size: 30),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card à gauche
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Recomandcard1(title: 'Your goal is', goal: 'gain weight'),
            ),

         const SizedBox(height: 20),

            // Options de profil
           AccountCard(),
           const SizedBox(height: 10),

            AccountCard2(),
          ],
        ),
      ),
    );
  }

 
}

class Recomandcard1 extends StatelessWidget {
  final String title;
  final String goal;

  const Recomandcard1({
    super.key,
    required this.title,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 189, 210, 255), Color(0xFFf7f8fc)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            goal,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


class AccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildOption(Icons.person, ' First Name','firstname'),
            _buildOption(Icons.person,'Last Name','lastname'),
            _buildOption(Icons.email, 'Email','email'),
            _buildOption(Icons.password, ' Password','password'),
            _buildOption(Icons.fitness_center, 'Weight','weight'), 
            _buildOption(Icons.straighten, 'Height','height'),
               _buildOption(Icons.track_changes, 'Goal','goal'),
            _buildOption(Icons.calendar_month, 'Age','age'),
            
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title , String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9fbef7),size: 30,),
      title: Text(title),
      subtitle: Text(subtitle),
   
    );
  }
}
class AccountCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            _buildOption(Icons.logout, 'Logout', 'logout'),
              // Action à effectuer lors de l'appui sur le bouton "Logout"
          
            _buildOption(Icons.delete, 'Delete account', 'delete_account'),
            
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title , String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 215, 8, 8),
      size: 30,),
      title: Text(title),textColor: Colors.red,

      onTap: () { if (title == 'Logout') {
          // Action à effectuer lors de l'appui sur le bouton "Logout"
          // Par exemple, naviguer vers la page de connexion ou supprimer le token d'authentification
        } else if (title == 'Delete account') {
          // Action à effectuer lors de l'appui sur le bouton "Delete account"
          // Par exemple, afficher une boîte de dialogue de confirmation avant de supprimer le compte
        }
        
      },
    );
  }
}