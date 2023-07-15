import 'package:metro_mate/Variables.dart';

class Graph {
  late Map<String, Set<String>> graph;

  Graph() {
    graph = metroGraph;
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