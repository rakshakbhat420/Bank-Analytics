use bank_loan;
select * from fin1;

select * from fin1 F1
inner join fin2 F2
on F1.id=F2.id;

select * from fin1;

/*alter table fin1
modify Issue_d date;*/

-- KPI 1--

/*SELECT YEAR(ISSUE_D) AS YEAR, LOAN_STATUS, sum(LOAN_AMNT) AS LOAN_AMNT FROM FIN1 
GROUP BY LOAN_STATUS, YEAR(ISSUE_D) ORDER BY year(ISSUE_D) DESC;*/
select concat(20,right(last_credit_pull_d,2)) as year,sum(loan_amnt) as "sum of loan amount" from finance1 join finance2 using(id) 
group by year by year limit 1,12;


-- KPI 2. GRADE & SUBGRADE  WISE REVOLVE BALANCE__

SELECT GRADE,SUB_GRADE, SUM(REVOL_BAL) AS REVOL_BAL FROM FIN1 
JOIN FIN2 USING(ID) GROUP BY GRADE, SUB_GRADE ORDER BY GRADE, SUB_GRADE;

-- KPI 3-- Total Payment for Verified Status Vs Total Payment for Non Verified Status


Set sql_safe_updates=0;
Update fin1 set verification_status = 'Verified' where  verification_status = 'source verified';

select verification_status, round(sum(total_pymnt),2) as Total_payment from Fin1 inner join fin2 using (id)
where verification_status in('verified', 'Not Verified')
group by verification_status; 


-- KPI 4-- State wise and month wise loan status


select addr_state, last_credit_pull_d, loan_status from fin1 join fin2 using(id)
group by addr_state, last_credit_pull_d, loan_status
order by addr_state;


-- KPI 5-- Home ownership Vs last payment date stats

select home_ownership, last_pymnt_d as last_pymnt_date, sum(last_pymnt_amnt)
from fin1 f1 inner join fin2 f2
on(f1.id=f2.id)
where last_pymnt_d in(select max(str_to_date(f2.last_pymnt_d,'%d/%m/%y'))from fin2)
group by last_pymnt_d,home_ownership
having sum(last_pymnt_amnt) =
(  select sum(last_pymnt_amnt)
from fin2 f2 join fin1 f1
on(f1.id=f2.id)
group by last_pymnt_d,home_ownership
);

select last_pymnt_d,sum(last_pymnt_amnt) ,home_ownership
from fin2 f2 join fin1 f1
on(f1.id=f2.id)
group by last_pymnt_d,home_ownership
order by last_pymnt_d desc;









