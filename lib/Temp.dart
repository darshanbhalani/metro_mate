

class Graph {
  late Map<String, Set<String>> graph;

  Graph() {
    graph = {
      'Gyaspur Depot': {'APMC'},
      'APMC': {'Gyaspur Depot', 'Jivraj'},
      'Jivraj': {'APMC', 'Rajivnagar'},
      'Rajivnagar': {'Jivraj', 'Shreyas'},
      'Shreyas': {'Rajivnagar', 'Paldi'},
      'Paldi': {'Shreyas', 'Gandhigram'},
      'Gandhigram': {'Paldi', 'Old High Court 1'},
      'Old High Court 1': {'Gandhigram', 'Usmanpura', 'Stadium', 'Sahpur'},
      'Usmanpura': {'Old High Court 1', 'Vijaynagar'},
      'Vijaynagar': {'Usmanpura', 'Vadaj'},
      'Vadaj': {'Vijaynagar', 'Ranip'},
      'Ranip': {'Vadaj', 'Sabarmati Railway Station'},
      'Sabarmati Railway Station': {'Ranip', 'AEC'},
      'AEC': {'Sabarmati Railway Station', 'Sabarmati'},
      'Sabarmati': {'AEC', 'Motera Stadium'},
      'Motera Stadium': {'Sabarmati'},
      'Stadium': {'Old High Court 1', 'Commerce Six Roads'},
      'Commerce Six Roads': {'Stadium', 'Gujarat University'},
      'Gujarat University': {'Commerce Six Roads', 'Gurukul Road'},
      'Gurukul Road': {'Gujarat University', 'Doordarshankendra'},
      'Doordarshankendra': {'Gurukul Road', 'Thaltej'},
      'Thaltej': {'Doordarshankendra', 'Thaltej Gam'},
      'Thaltej Gam': {'Thaltej'},
      'Sahpur': {'Old High Court 1', 'Gheekanta'},
      'Gheekanta': {'Sahpur', 'Kalupur Railway Station'},
      'Kalupur Railway Station': {'Gheekanta', 'Kankaria East'},
      'Kankaria East': {'Kalupur Railway Station', 'Apparel Park'},
      'Apparel Park': {'Kankaria East', 'Amraivadi'},
      'Amraivadi': {'Apparel Park', 'Rabari Colony'},
      'Rabari Colony': {'Amraivadi', 'Vastral'},
      'Vastral': {'Rabari Colony', 'Nirant Cross Road'},
      'Nirant Cross Road': {'Vastral', 'Vastral Gam'},
      'Vastral Gam': {'Nirant Cross Road'}
    };
  }

  List<String>? bfs(String start, String goal) {
    if (!graph.containsKey(start) || !graph.containsKey(goal)) {
      return null; // Either start or goal node does not exist in the graph
    }

    Set<String> visited = {};
    List<List<dynamic>> queue = [[start, []]];

    while (queue.isNotEmpty) {
      List<dynamic> nodeInfo = queue.removeAt(0);
      String node = nodeInfo[0];
      List<String> path = List<String>.from(nodeInfo[1]);

      if (node == goal) {
        path.add(node);
        return path; // Return the path from start to goal
      }

      if (!visited.contains(node)) {
        visited.add(node);
        path.add(node);

        Set<String>? neighbors = graph[node];
        if (neighbors != null) {
          for (String neighbor in neighbors) {
            if (!visited.contains(neighbor)) {
              queue.add([neighbor, List<String>.from(path)]); // Create a copy of the path
            }
          }
        }
      }
    }

    return null; // Return null if no path is found
  }
}