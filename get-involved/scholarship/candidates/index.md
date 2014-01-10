---
layout: basic
alias: /scholarshipcandidates
title: Scholarship A Student
---
*Kingdom Building Ministries* believes that the Kingdom impact of one life laboring with a heart on fire and a life on purpose creates exponential impact. Jesus intentionally invested much of his time with a few men who impacted the world for the glory of God. [KBM Discipleship Training](/training) seeks to create an environment where students will encounter God in life-changing ways.

**YOUR INVESTMENT IN PROVIDING A SCHOLARSHIP TO ONE LIFE HAS GREAT KINGDOM VALUE!**

In addition to their personal investment, each student is asked raise support for their training. This creates an opportunity for them to encounter God as Provider. However, the students listed below have limited resources and are unable to raise the full tuition they need.

**WOULD YOU CO-LABOR WITH THESE STUDENTS TO ARE RIGHT NOW WALKING THIS FAITH JOURNEY?**

{% for student in site.categories.candidates %}

<div class="row">
  <div class="kbm-full-col">
   <div class="kbm-program-content-box gray">
   
 <h1>{{student.name}}</h1>
   
   </div>
  </div>
</div>

<div class="row">
  <div class="kbm-full-col">
    <div class="kbm-program-content-box gray">
      <div class="row">
        <div class="kbm-third-col">
          <img src="{{student.picurl}}"/>
        </div>
        
        <div class="kbm-third-col">
          <h3> Program:
          {% case student.program %}
          {% when 'experience' %}
          <a href="/theexperience">The Experience</a>
          {% when '16days' %}
          <a href="/16days">16 Days</a>
          {% when 'deepcamp' %}
          <a href="/deepcamp">Deep Camp</a>
          {% endcase %}
          </h3>
          <h3>Country: {{student.country}}</h3>
        </div>
        <div class="kbm-third-col">
          {{student.dpurl}}
        </div>
      </div>
    </div>
  </div>
</div>

{% endfor %}