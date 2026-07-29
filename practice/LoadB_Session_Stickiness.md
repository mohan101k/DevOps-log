<img width="1536" height="1024" alt="ChatGPT Image Jul 29, 2026, 10_24_58 PM" src="https://github.com/user-attachments/assets/fef45c13-cebd-4b11-a65f-1818e938fb7f" />


This Step Afterr You Have Successfuly 2 Instance with AlB And after cheaching health cheack


Target Group Status
Healthy (2/2)
        │
        ▼
1. Copy the ALB DNS Name
        │
        ▼
2. Open the ALB DNS in a Browser
        │
        ▼
3. Verify the Application is Accessible
        │
        ▼
4. Refresh Multiple Times
   (Traffic moves between Server-1 & Server-2)
        │
        ▼
5. Go to Target Group
        │
        ▼
6. Open the "Attributes" Tab
        │
        ▼
7. Click "Edit"
        │
        ▼
8. Enable Session Stickiness
        │
        ▼
9. Select:
   • Load Balancer Generated Cookie
   • Duration: 60 Seconds (Lab)
        │
        ▼
10. Save Changes
        │
        ▼
11. Open the ALB DNS Again
        │
        ▼
12. Refresh 10–15 Times
        │
        ▼
13. Verify the Same Server Appears Every Time
        │
        ▼
14. Wait 60 Seconds (Cookie Expires)
        │
        ▼
15. Refresh Again
        │
        ▼
16. ALB May Route to Another Healthy Server
        │
        ▼
17. (Optional) Test Using Incognito Browser
