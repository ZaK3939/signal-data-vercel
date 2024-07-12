import fs from 'fs';
import { Command } from 'commander';

interface Project {
  name: string;
  description: string;
  avatar: string;
  url: string;
  timestamp: number;
  chains: string[];
  categories: string[];
  twitterHandle: string;
  website: string;
}

function searchProjects(projects: Project[], searchQuery: string): Project[] {
  const regex = new RegExp(searchQuery, 'i');
  return projects.filter((project) => regex.test(project.name));
}

function main() {
  const program = new Command();
  program.argument('<searchQuery>', 'Search query for project name').action((searchQuery) => {
    const rawData = fs.readFileSync('./script/project-data.json', 'utf8');
    const projects: Project[] = JSON.parse(rawData);

    const searchResults = searchProjects(projects, searchQuery);

    if (searchResults.length === 0) {
      console.log(`No projects found matching the search query: ${searchQuery}`);
    } else {
      console.log(`Search results for query: ${searchQuery}`);
      console.log(JSON.stringify(searchResults, null, 2));
    }
  });

  program.parse(process.argv);
}

main();
