class Graph {
  late Map<String, Set<String>> graph;

  Graph() {
    graph = {
      'Gyaspur Depot': {'APMC'},
      'APMC': {'Gyaspur Depot', 'Jivrajpark'},
      'Jivrajpark': {'APMC', 'Rajivnagar'},
      'Rajivnagar': {'Jivrajpark', 'Shreyas'},
      'Shreyas': {'Rajivnagar', 'Paldi'},
      'Paldi': {'Shreyas', 'Gandhigram'},
      'Gandhigram': {'Paldi', 'Old High Court 1'},
      'Old High Court 1': {'Gandhigram', 'Usmanpura', 'SP Stadium', 'Shahpur'},
      'Usmanpura': {'Old High Court 1', 'Vijaynagar'},
      'Vijaynagar': {'Usmanpura', 'Vadaj'},
      'Vadaj': {'Vijaynagar', 'Ranip'},
      'Ranip': {'Vadaj', 'Sabarmati Railway Station'},
      'Sabarmati Railway Station': {'Ranip', 'AEC'},
      'AEC': {'Sabarmati Railway Station', 'Sabarmati'},
      'Sabarmati': {'AEC', 'Motera Stadium'},
      'Motera Stadium': {'Sabarmati'},
      'SP Stadium': {'Old High Court 1', 'Commerce Six Roads'},
      'Commerce Six Roads': {'SP Stadium', 'Gujarta University'},
      'Gujarta University': {'Commerce Six Roads', 'Gurukul Road'},
      'Gurukul Road': {'Gujarta University', 'Doordarshankendra'},
      'Doordarshankendra': {'Gurukul Road', 'Thaltej'},
      'Thaltej': {'Doordarshankendra', 'Thaltej Gam'},
      'Thaltej Gam': {'Thaltej'},
      'Shahpur': {'Old High Court 1', 'Gheekanta'},
      'Gheekanta': {'Shahpur', 'Kalupur Metro Station'},
      'Kalupur Metro Station': {'Gheekanta', 'Kankaria East'},
      'Kankaria East': {'Kalupur Metro Station', 'Apperel Park'},
      'Apperel Park': {'Kankaria East', 'Amraivadi'},
      'Amraivadi': {'Apperel Park', 'Rabari Colony'},
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