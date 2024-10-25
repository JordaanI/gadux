Gadux

Gadux is a state management system written in Gambit Scheme, inspired by Redux. It is designed to be fully functional in the programming sense, providing a robust and flexible way to maintain and manage state in your application. Gadux allows state to be dynamically rebuilt whenever components are modified, ensuring that your application remains up-to-date with the latest changes.

Features

State Rebuilding: Gadux automatically rebuilds the state when components are modified, allowing for dynamic updates to the application state.
Component-Based Architecture: Gadux organizes the state into components. Each component contains the data and the procedures (functions) that act on that data.
Cross-Component Communication: Procedures within one component can call procedures in other components, enabling a high degree of modularity and interaction between different parts of your application.
Data-Only Components: Not all components need to be executable. Some can simply carry data, acting as passive elements of the state.
Why Gadux?

Gadux is ideal for Scheme developers looking for a powerful and flexible state management system. While inspired by Redux, it leverages the functional programming paradigm to allow components to carry not just data, but also the logic that acts on that data, promoting a more integrated approach to state management.
