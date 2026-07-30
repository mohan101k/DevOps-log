🚀 Task 2: Schedule-Based Scaling (Hinglish Introduction)
📖 Kya hai Schedule-Based Scaling?

Schedule-Based Scaling ka matlab hai ki Auto Scaling Group (ASG) automatically ek fixed time par EC2 instances launch ya terminate karta hai.

Isme scaling CPU ya Traffic ke basis par nahi, balki time schedule ke basis par hoti hai.

📌 Example

Suppose ek company ka office 10:00 AM se 12:00 AM tak hi open rehta hai.

10:00 AM → Employees login karna start karte hain.
Website par load increase hota hai.
ASG automatically 2 EC2 instances create kar deta hai.

Raat ko:

12:00 AM
Office band.
Users nahi hain.
ASG automatically extra EC2 instances terminate kar deta hai.
Sirf required instances hi chalte hain ya desired capacity 0/1 ho jati hai.

👉 Isse company unnecessary server cost save karti hai.

🎯 Why Use Schedule-Based Scaling?
✅ Office Hours Applications
✅ Banking Applications
✅ College ERP Systems
✅ Company Employee Portals
✅ Training Portals
✅ School Management Systems

Jahan traffic ka time pehle se predictable ho.

🌍 Real-Time Example

Amazon Customer Support Portal

Morning 10:00 AM → More support agents login.
ASG automatically launches more EC2 instances.
Night 12:00 AM → Most agents log out.
ASG automatically terminates extra instances.

Isse performance bhi maintain hoti hai aur cost bhi optimize hoti hai.

💼 Interview Answer

Q: What is Schedule-Based Scaling?

Schedule-Based Scaling is an Auto Scaling feature that automatically launches or terminates EC2 instances at predefined dates and times. It is useful for applications with predictable traffic patterns, such as office-hour workloads.
