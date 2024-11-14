# Product Analytics Case Study

## Overview
This case study explores the [topic of analysis] to address key questions and provide insights on [objective]. Using a data-driven approach, this project aims to uncover actionable insights and recommendations for improving [relevant area, e.g., product performance, user engagement].

## Table of Contents
- [Overview](#overview)
- [Optimising resolution window data and Methodology](#optimising-resolution-window-data-and-methodology)
- [Channel Transition Analysis](#channel-transition-analysis)
- [Resolution Success Channel](#resolution-success-channel)
- [How to Use This Repository](#how-to-use-this-repository)
  
## Overview
In the context of this analysis, the data model is an abstraction that describes how different data elements are structured and relate to each other within the customer support operations. Specifically, the data model involves:

## Optimising resolution window data and Methodology

Objective
The primary goal of this analysis is to determine an optimal resolution window by examining the frequency of repeat contacts and calculating first-contact resolution rates. Specifically, we aim to:
Identify non-first contact resolution cases with a focus on follow-up contact intervals within 5 and 7 days.
Calculate first-contact resolution cases, where there is no preceding or following contact within the specified window (5 or 7 days).
Provide statistical insights, including average and median days between contacts, to inform the optimal resolution timeframe.
Methodology
Step 1: Data Preparation
Extract raw data, converting timestamps into a compatible format for date calculations.
Organise each merchant’s interactions by timestamp, identifying previous (PREV_CONTACT_DATE) and subsequent contacts (NEXT_CONTACT_DATE) using SQL window functions.
Step 2: Define Contact Intervals
Calculate DAYS_SINCE_LAST_CONTACT and DAYS_TO_NEXT_CONTACT for each interaction to understand the time gaps between consecutive interactions.
Step 3: Categorise Contact Resolution Types
Classify each contact based on the intervals between contacts:
Non-First Contact Resolution: A contact with a follow-up interaction within either 5 or 7 days, indicating that the issue required additional engagement.
First Contact Resolution: A contact with no follow-up within either 5 or 7 days, signaling that the issue was resolved upon the initial engagement.
Step 4: Calculate Resolution Statistics For each contact type, calculate:
Average and Median Days Between Contacts: Statistical metrics to observe typical intervals between follow-up contacts in non-first contact resolution cases.
Counts and Percentages:
Non-first contact resolutions within 5 and 7 days (count and percentage of total).
First-contact resolutions within 5 and 7 days (count and percentage of total).


## Channel Transition Analysis

To provide a more intuitive understanding of journey transitions between support channels, I am looking at following metrics for the analysis.
Overall Transition Rates:
Calculate the percentage of total contacts transitioning from one channel to another. This helps identify common flows and potentially problematic transitions.
For each CHANNEL -> NEXT_CHANNEL pair:
Transition Rate (%) = (Transition Count / Total Contacts from Initial Channel) * 100
For instance, Chat to Email Transition for SUP - Onboarding: 2,072 / (Total SUP - Onboarding via Chat) gives the percentage of chats that escalate to email. A high percentage might suggest chat isn’t fully effective for onboarding issues, necessitating escalation.
Channel Retention vs. Escalation:
Retention Rate: Measure how often interactions remain within the same channel (e.g., call -> call or chat -> chat).
Retention Rate (%) = (Count of Interactions Retained in Same Channel / Total Contacts per Channel) * 100
Escalation Rate: Calculate the percentage of interactions that escalate to another channel (e.g., chat -> email or call -> email).
Escalation Rate (%) = (Count of Escalations to Different Channels / Total Contacts per Channel) * 100
How to interpret - Low retention rates could indicate inefficiencies in resolving issues within a channel.
Dominant Channel Transitions:
Identify transitions with a high percentage share from a particular channel.
If 30% of all chat interactions for Logistics - Shipping end in a call, investing in a richer chat experience may help minimize these transitions.
Topic-Channel Analysis 
For topic-channel analysis, incorporating percentage metrics provides a clearer picture of channel efficiency and topic handling:
Percentage of Topic per Channel:
Measure the percentage share of each topic handled by a specific channel to understand which channel is most effective for different issues.
Channel Preference (%) = (Contacts for a Topic via Channel / Total Contacts for the Topic) * 100
For SUP - Onboarding, Chat Share is (2,072 / 34,249) * 100 = 6.05%, whereas Email Share is (32,177 / 34,249) * 100 = 93.95%. This suggests that onboarding is mainly handled via email, indicating its suitability for more complex processes.


## Resolution Success Channel

Calculate the first-contact resolution rate per topic and channel to assess channel effectiveness in resolving issues.
Metric:
First Contact Resolution Rate (%) = (First Contact Resolutions via Channel / Total Contacts for the Topic via Channel) * 100
Low first-contact resolution rates for certain channels (e.g., chat) might indicate a need for better support tools or training.

Escalation Impact Analysis:
Calculate the percentage of escalations for each topic to understand which issues need frequent escalations and which channels are not adequately resolving issues.
Escalation Impact (%) = (Contacts Transitioning to Another Channel / Total Contacts per Topic) * 100
Identifying high escalation rates (e.g., 60% of Logistics - Shipping queries moving from chat to call) can highlight areas where specific channel improvements are needed.
Metrics Calculation
Channel Transition Analysis for SUP - Profile:
Call to Call Retention Rate (%): (14,200 / 15,346) * 100 = 92.52%. This high rate suggests strong retention but could indicate difficulty in fully resolving issues during a single call.
Escalation to Email Rate (%): (1,082 / 15,346) * 100 = 7.05%. Indicates moderate escalation, suggesting the need for enhanced resolution capabilities during calls.
Topic-Channel Analysis for SUP - Onboarding:
Chat Share for SUP - Onboarding (%): (2,072 / 34,249) * 100 = 6.05%. Suggests that chat is not a preferred channel for onboarding.
Email Share for SUP - Onboarding (%): (32,177 / 34,249) * 100 = 93.95%. Indicates email’s effectiveness for handling onboarding.




## How to Use This Repository
### Installation
Clone this repository and install the dependencies:
```bash
git clone https://github.com/nehasingh1902/CaseStudy.git
cd CaseStudy
pip install -r requirements.txt
