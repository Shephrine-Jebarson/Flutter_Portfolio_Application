import 'project.dart';

/// Sample project data for the portfolio
final List<Project> sampleProjects = [
  Project(
    id: 1,
    title: "Voting System",
    category: "System Programming",
    description: "A secure and efficient voting system allowing users to cast votes reliably. Designed with a focus on simplicity, accuracy, and controlled input handling.",
    techStack: "C",
    platform: "Console Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/voting-system",
    highlights: "Input validation, structured logic, secure vote counting",
  ),
  Project(
    id: 2,
    title: "Election Simulator",
    category: "Object-Oriented Programming",
    description: "A console-based classroom election simulator implementing core OOP principles such as classes, objects, inheritance, and encapsulation.",
    techStack: "C++",
    platform: "Console Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/election-simulator",
    highlights: "OOP design, modular code, data handling",
  ),
  Project(
    id: 3,
    title: "Class Pulse",
    category: "EdTech Application",
    description: "An application designed to enhance student engagement in classroom activities through interactive feedback and participation features, supported by AI tools.",
    techStack: "AI Tools, Web Technologies",
    platform: "Web / Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/class-pulse",
    highlights: "Student engagement, interactive features, AI integration",
  ),
  Project(
    id: 4,
    title: "MeetWise.AI",
    category: "AI Automation",
    description: "An AI-powered meeting assistant built on the Workato platform that summarizes Google Meet sessions, emails summaries to participants, and automatically updates tasks in Jira.",
    techStack: "Workato, OpenAI, Jira API",
    platform: "Automation Platform",
    status: "In Progress",
    githubLink: "https://github.com/yourusername/meetwise-ai",
    highlights: "Meeting summarization, workflow automation, task tracking",
  ),
  Project(
    id: 5,
    title: "DigiBus",
    category: "Smart Campus Solution",
    description: "A smart transportation management system for college campuses featuring real-time GPS tracking, WebSocket-based updates, geofencing alerts, and an admin monitoring dashboard.",
    techStack: "React, WebSocket, GPS, PWA",
    platform: "Progressive Web Application",
    status: "In Progress",
    githubLink: "https://github.com/yourusername/digibus",
    highlights: "Live tracking, ETA prediction, geofencing alerts, scalable architecture",
  ),
];

/// Detailed project content for the project detail screen
final Map<int, Map<String, String>> projectDetails = {
  1: {
    'overview': 'The Voting System is a console-based application developed in C that allows users to cast votes in a secure and structured manner. The primary objective of this project was to understand low-level programming concepts and implement a reliable voting mechanism with controlled user input.',
    'problem': 'Traditional manual voting methods are prone to errors such as duplicate votes, invalid inputs, and inaccurate counting. Even at a small scale, managing votes without validation can lead to incorrect results.',
    'solution': 'This project provides a simple yet effective voting system where users can view available candidates, cast votes securely, ensure each vote is recorded correctly, and display accurate vote counts and results.',
    'features': 'Input validation to prevent invalid entries • Structured logic for vote counting • Clear result display • Efficient memory usage',
    'learning': 'Control structures and loops • Functions and modular programming • Secure input handling • Writing efficient and readable C code',
  },
  2: {
    'overview': 'The Election Simulator is a console-based application built using C++, designed to simulate a classroom election process. The focus of this project was to apply Object-Oriented Programming (OOP) concepts in a practical scenario.',
    'problem': 'Managing elections manually in small environments such as classrooms can become confusing and unstructured, especially when handling candidates, voters, and results separately.',
    'solution': 'The application simulates a complete election flow by modeling real-world entities using OOP principles. Each component of the election process is represented as an object, ensuring clarity and modularity.',
    'features': 'Use of classes and objects to represent candidates and voters • Encapsulation of data for security and clarity • Inheritance to reduce redundancy • Clean separation of logic and data',
    'learning': 'Object-oriented design • Code reusability and scalability • Data abstraction and encapsulation • Logical structuring of real-world problems',
  },
  3: {
    'overview': 'Class Pulse is an application aimed at improving student engagement during classroom sessions. The application introduces interactive elements that allow students to actively participate and provide feedback, making learning more engaging and dynamic.',
    'problem': 'Traditional classroom environments often lack real-time feedback and interaction, leading to reduced student participation and engagement.',
    'solution': 'Class Pulse introduces a digital platform where students can participate in interactive activities, provide feedback during sessions, and engage through AI-powered features that encourage involvement.',
    'features': 'Interactive engagement modules • Feedback collection mechanisms • AI-assisted interaction tools • User-friendly interface for students',
    'learning': 'Designing applications focused on user engagement • Integrating AI tools into real-world applications • Improving UX for educational platforms • Understanding user behavior in learning environments',
  },
  4: {
    'overview': 'MeetWise.AI is an AI-powered automation solution developed on the Workato platform. It automates post-meeting workflows by summarizing Google Meet sessions and synchronizing tasks with project management tools.',
    'problem': 'Meetings often result in lost information, missed action items, and delayed follow-ups due to manual note-taking and task updates.',
    'solution': 'MeetWise.AI automates the entire post-meeting process by generating concise meeting summaries, emailing summaries to all participants, and automatically updating tasks in Jira.',
    'features': 'AI-based meeting summarization • Automated email distribution • Seamless task synchronization with Jira • Reduced manual effort and improved productivity',
    'learning': 'AI-driven workflow automation • Integration between multiple enterprise tools • Designing scalable automation solutions • Real-world use of AI in productivity tools',
  },
  5: {
    'overview': 'DigiBus is a smart transportation management system designed specifically for college campuses. It provides real-time bus tracking, predictive updates, and administrative monitoring through a modern digital platform.',
    'problem': 'Conventional campus transportation systems rely on static schedules and manual coordination, leading to uncertainty, delays, and inefficiencies for both students and administrators.',
    'solution': 'DigiBus introduces a real-time, user-centric transportation platform that tracks buses using GPS, updates location every five seconds via WebSockets, provides ETA predictions to students, and sends geofencing-based notifications.',
    'features': 'Live bus tracking with real-time updates • ETA prediction and alerts • Admin dashboard for fleet monitoring • Predictive maintenance notifications • Cross-platform access via PWA',
    'learning': 'Real-time systems and WebSocket communication • Scalable application architecture • Smart campus solutions • Designing data-driven, user-centric platforms',
  },
};
