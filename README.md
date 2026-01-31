# SPI_Slave-with-Single_Port-RAM
📌 SPI Slave with Single-Port RAM:

This project implements an SPI Slave module integrated with a Single-Port RAM.
The SPI interface allows a master device to communicate serially with the slave in order to read from and write to the internal memory.

🎯 Project Objective:

The main objective of this project is to design and verify an SPI slave system that can:

Receive data from an SPI master and store it in RAM

Read stored data from RAM and transmit it back to the master

Demonstrate understanding of serial communication protocols and memory interfacing

⚙️ System Overview:

The SPI Slave receives commands, addresses, and data through the SPI protocol

Based on the received command, the slave performs read or write operations on a single-port RAM

Data is exchanged serially via MOSI/MISO, synchronized with SPI clock

🧩 Key Features:

SPI Slave implementation

Single-Port RAM integration

Supports read and write operations

Synchronous operation with SPI clock

Suitable for digital design and verification practice

🛠 Tools & Technologies:

Hardware Description Language: Verilog

Simulation: QuestaSim

Design & Testing: Digital IC Design concepts
