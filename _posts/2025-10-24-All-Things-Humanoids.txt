---
layout: post
title: All about humanoids 
categories: [humanoids]
tags: [robotics, history, elektro, westinghouse]
excerpt: "Exploring the fascinating history of humanoid robots, starting with Elektro - the world's first humanoid built in 1939."
---

The first humanoid in the world was Elektro. This was built in 1939 by Westinghouse Electric Corporation from Ohio (🤩).

Quoting from [Wiki](https://en.wikipedia.org/wiki/Elektro):

> Seven feet tall (2.1 m), weighing 265 pounds (120 kg), humanoid in appearance, he could walk by voice command, speak about 700 words (using a 78-rpm record player), smoke cigarettes, blow up balloons, and move his head and arms. Elektro's body consisted of a steel gear, cam and motor skeleton covered by an aluminum skin. His photoelectric "eyes" could distinguish red and green light. <br> <br> <br> Elektro was on exhibit at the 1939 New York World's Fair and was joined at that fair in 1940, with "Sparko", a robot dog that could bark, sit, and beg to humans.
> 

Westinghouse Electric Corp. no longer exists today.

In 1998, Honda published a paper on "The Development of Honda Humanoid Robot" at the International Conference on Robotics & Automation. The goal of this humanoid was to coexist and collaborate with humans, and to perform tasks that humans cannot. Honda believed that a robot working within a household is the type of robot that consumers may find useful. They referred to it as a "Domestic Robot." They marked this prototype as P2.

### Honda P2 Humanoid Robot Specifications

### Degrees of Freedom

- Legs: 12 DOF total
    - Hip: 3 joints
    - Knee: 1 joint
    - Ankle: 2 joints
- Arms: 14 DOF total
- Hand: 2-fingered gripper with 2 DOF

### Performance

- Maximum walking speed: 4.7 km/h (2.92 mph)
- Payload capacity: 70 kg

### Physical Dimensions

- Height: 5'11"
- Width: 23"

### Sensors

- Inclination sensor
- Ground reaction force sensor for each foot
- Camera sensors used for:
    - Vision processing
    - Target position estimation
    - Inspection (e.g., chemical plant equipment)
    - Teleoperation
- Force and torque sensor for each wrist (for arm force control)

### Design Considerations

- Arm length determined by the required ability to pick up objects from the floor while in a squatting posture

### Actuation

- Joints actuated by DC motors with harmonic-drive reduction gear

### Computing System

- 4 microprocessors for:
    - Arm control
    - Leg control
    - Local control of joints
    - Vision processing
- Operating System: VxWorks
- DC servo amplifiers
- Wireless ethernet modem

### Power System

- NiZn battery for electronic components and actuators
- Battery weight: 20 kg (44 lbs)
- Power consumption: 3 kW during walking
- Battery runtime: approximately 15 minutes
- External power supply option available

## Physics Fundamentals for Humanoid Robotics

### Understanding Inertia

To understand how humanoid robots maintain balance, we first need to revisit some basic physics concepts that govern motion and stability.

- **Inertia of Motion:** When a moving car suddenly brakes, passengers lurch forward. This demonstrates a body's tendency to continue moving.
- **Inertia of Rest:** When a car accelerates from a stop, passengers feel pushed backward. This shows a body's resistance to starting motion.
- **Inertia of Direction:** During a sharp turn (like a drift), passengers feel pressed against the car door, illustrating resistance to directional change.
- In essence, inertia is resistance to change in motion.
- **Newton's First Law:** A body remains in its state of rest or uniform motion unless an external force acts upon it.

### Applying Physics to Robot Balance Control

Honda applied these principles to develop P2's posture stabilization system using several key concepts:

- **Desired Total Inertia Force:** The combination of the ideal walking pattern's inertia force and gravity force.
- **Desired Zero Moment Point (Desired ZMP):** The point on the ground where the moment of the desired total inertia force becomes zero.
- **Actual Total Ground Reaction Force (ATGRF):** The combined ground reaction forces acting on both feet of the robot.
- **Center of Actual Ground Reaction Force (C-ATGRF):** The point on the ground where the moment of ATGRF becomes zero.
- The tipping moment for the robot is calculated using:
$$\text{Tipping moment} = ((\text{Desired ZMP}) - (\text{C-ATGRF})) \times \text{Vertical element of desired total inertia force}$$

While ATGRF and C-ATGRF are complex concepts, Honda successfully used them to build effective posture stabilization and recovery control systems in their humanoid robots.

## Evolution: From Humanoid P2 to P3

Prototype 3 (P3) addressed P2's key limitations. Honda recognized that P2 was far too large and heavy for practical applications. The P3 design reduced the robot's height to 160cm (approximately 5'3") and weight to 130 kg (280 lbs). Additionally, existing motors were replaced with brushless DC motors, which significantly improved the robot's reliability.

## ASIMO's Journey

Honda's humanoid development culminated in ASIMO, which demonstrated remarkable [progress](https://global.honda/en/robotics/asimo/) over its lifetime:

- Operated for 20 years
- Took 33.26 million steps
- Walked a distance equivalent to 7,907 km (4,913 miles)

---

## Modern Humanoid Development and Role of Machine Learning

Today, a new generation of companies is advancing humanoid robotics. Boston Dynamics, Tesla, Unitree, and Figure are among the leading organizations developing cutting-edge humanoid platforms.

### The Role of AI and Machine Learning

Below learnings and observations are from Sferrazza et al. 2024 HumanoidBench paper.

One basic question I have with respect to humanoids or robotics in general is, ***do all humanoids operate with AI/machine learning***? 

Apparently the answer is “**no”**. Most humanoid robots still rely primarily on hand-designed controllers for their hardware. Specific tasks often require significant engineering efforts tailored to each new task and environment. Current systems typically demonstrate only limited whole-body control capabilities.

### What are the key learning challenges for Humanoids?

Humanoid robots must master two fundamental capabilities:

- Robotic manipulation
- Locomotion

### Scaling Challenges for Learning Algorithms

What are the challenges of scaling learning algorithms to humanoid robots? 

The complexity increases significantly with the dimensionality of the state and action spaces, requiring more sophisticated approaches to training.

### Simulation Environments

To train humanoid robots efficiently, researchers use physics-based simulation environments:

- MuJoCo - A high-performance physics engine for robotics simulation

### HumanoidBench: A Comprehensive Benchmark Dataset

The HumanoidBench benchmark provides a standardized evaluation framework with:

- 12 tasks for locomotion
- 15 tasks for manipulation
- 27 tasks in total

### State-of-the-Art Reinforcement Learning Algorithms

Current leading algorithms for humanoid learning include:

- **Dreamer V3:** SOTA model-based RL algorithm that learns from imaginary model rollouts
- **TD-MPC2:** SOTA model-based RL algorithm with online planning capabilities
- **SAC:** SOTA off-policy model-free RL algorithm
- **PPO:** SOTA on-policy model-free RL algorithm

### Current Limitations and Insights

> All the baseline algorithms perform below the success threshold on most tasks, particularly struggling on tasks that require long-horizon planning and intricate whole-body coordination in high-dimensional action space. Surprisingly, these SOTA RL algorithms require a large number of steps to learn even simple locomotion tasks, such as walk, which has been extensively studied with a simplified humanoid agent in the DeepMind Control Suite.
> 

This reveals a surprising insight: even walking—seemingly a solved problem—becomes significantly more challenging in high-dimensional state spaces. Unlike humans, who build fundamental skills that operate subconsciously (we don't forget how to walk while learning calculus or roller skating), current RL algorithms struggle to maintain basic capabilities while learning new tasks.

### Hierarchical Reinforcement Learning

Tasks requiring long-term planning and diverse skill sets can be addressed through hierarchical learning approaches, where additional structure is introduced into the learning problem. This helps manage the complexity of coordinating multiple capabilities simultaneously.

### Dimensionality of Humanoid Control

**Observation Space:** The Unitree H1 humanoid has 151 dimensions

- 51 for the humanoid robot body
- 50 for the left hand
- 50 for the right hand

**Action Space:** ||A|| = 61

- 19 for the human body
- 21 for each hand

### References

- Hirose et al. 2007 - Honda humanoid robots development
- Sferrazza et al. 2024 - HumanoidBench: Simulated Humanoid Benchmark for Whole-Body Locomotion and Manipulation [(arXiv)](https://arxiv.org/pdf/2403.10506)
