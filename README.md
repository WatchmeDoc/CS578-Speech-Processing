# Speech-Processing Projects

Projects for CS578 Speech Processing course ([link](https://www.csd.uoc.gr/~hy578/index.html)), Computer Science
Department in University of Crete, taught by Professor [Yannis Stylianou](https://www.csd.uoc.gr/CSD/index.jsp?custom=yannis_stylianou&lang=en).

Implemented in Matlab by George Manos and Alexandros Angelakis.

All projects include a small dataset of speech files, the project description and our final report.

# Short Descriptions

## 0-th Project - Part 1: Time domain of Speech

During this lab, you will have a first contact with speech signals and their short-time processing. You will see the
time domain structure of the most basic speech elements, such as vowels, plosives, and consonants. You will learn about
time domain properties of speech signals and you will calculate basic metrics on speech, such as energy and
zero-crossings. The final goal of this lab is to implement a simple adaptive, fully-automated voiced/unvoiced/silence (
VUS) discriminator. An algorithm of this kind is of practical use in real-time systems such as mobile communications
systems. A typical Voice Activity Detector (VAD), which is a subset of a VUS discriminator, is used in the Global System
for Mobile Communications (GSM), the European system for cellular communications. Of course, such an application should
be fast and efficient in real-time. Thus, the algorithm is based on energy measures and zero-crossings measures of the
speech signal. For this Lab, we will consider a non-real time approach. This means that we have the whole signal
available for our measures.

## 0-th Project - Part 2: Frequency domain of Speech

During this lab, you will have a first contact with frequency domain analysis of speech signals. You will see the
frequency domain structure of the most basic speech elements, such as vowels, plosives, and consonants, using the Fast
Fourier Transform (FFT). You will learn about time-frequency representation of speech signals, with the help of
Short-Time Fourier Analysis (spectrogram). The spectrogram can be produced using wideband or narrowband analysis.
Wideband analysis includes the use of short analysis window, whereas narrowband analysis is performed using long
analysis window. Finally, you will learn how to estimate basic components on speech, such as pitch. The goal of this lab
is to implement a simple system for speaker gender (male, female) and age (adult or children) detection.

## 1st Project: Linear Prediction

During this project you will explore the Linear Prediction theory and an implementation in MATLAB of a Linear Prediction
based Analysis and Synthesis system for speech. In the MATLAB code there are some incomplete command lines that are
waiting for you to fill them in. Once you do this, you can play with the code to do various speech modifications in an
input speech signal. In this project you will use the code in the MATLAB file: lpc_as_toyou.m. You will play with a
speech signal in a WAV format (speechsample.wav).

## 2nd Project: Sinusoidal Modeling

During this project you will explore the Sinusoidal Representation of speech signals and you will work with an
implementation in MATLAB of the Sinusoidal Model (SM) suggested by McAulay and Quatieri. In the provided MATLAB code,
there are some empty command lines that are waiting for you to fill in. Once you do this, you can play with the code to
perform speech analysis and synthesis based on SM. In this project you will use the code in the MATLAB file:
SinM_test_hy578.m. You will play with a speech signal in a wav format named arctic_bdl1_snd_norm.wav.

## 3rd Project: Vector Quantization & LPC Coding

During this project you will explore the quantization process. More specifically you will develop a uniform scalar
quantizer and a vector quantizer. You will apply this into the Linear Prediction algorithm studied during the 1st
project.

## 4th Project: Speech Enhancement

This is by far the shortest announcement of project in this course. During this project you will develop a speech
enhancement tool in MATLAB. You will use the techniques of Spectral Subtraction and Wiener Filtering.

## 5th Project: Speaker Identification

During this project you will develop an automatic speaker identification system. More specifically the identification
system is split into two modules; the features extraction module and the classification or machine learning module which
you will develop. You will use MFCCs as features and GMMs as classification module.