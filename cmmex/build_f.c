#include "global.h"

extern int 		n_gen, m_pv, s_pq;
extern nameptr	name_header;
extern funcptr	func_header;
extern nodeptr zero, one, mi_one;

extern FILE *fp1;


/*----------------function to return a pointer to new node---------*/
nodeptr new_node()
{
	nodeptr p;
	
	p=(nodeptr) mxCalloc(1,sizeof(struct node));
	p->del_flg='1';
	if (p==NULL) 
	{
		mexErrMsgTxt("ERROR! Out of Memory for New Node!");
		
	};
	return (p);
}
/*-----------------------------------------------------------------*/

/*----------------function to return a pointer to new name_element---------*/
nameptr new_name()
{
	nameptr p;
	
	p=(nameptr) mxCalloc(1,sizeof(struct name_elem));
	if (p==NULL) 
	{
		mexErrMsgTxt("ERROR! Out of Memory for New Name!");
	};
	return (p);
}
/*-----------------------------------------------------------------*/

/*----------------function to return a pointer to a node (old or new)---------*/
nodeptr find_node(head, in_name, in_id)

nameptr head;
char in_name[];
char in_id;

{
	nameptr p;
	
	if (head==NULL)				/* empty list */
	{
		p=new_name();
		name_header=p;
		strcpy(p->name,in_name);
		p->addr=new_node();
		p->next=NULL;
		p->addr->node_id=in_id;
		if (in_id=='v') strcpy(p->addr->node_data.va_term.v_name,in_name);
		if (in_id=='c') 
		{
			strcpy(p->addr->node_data.cn_term.c_name,in_name);
			p->addr->node_data.cn_term.c_value=123.45;	
			/* any initial value other than 0 and 1 */
		}
		return(p->addr);
	}
	
	p=head;	
	while ((strcmp(p->name,in_name)!=0)&&(p->next!=NULL))	p=p->next;
	
	if (strcmp(p->name,in_name)==0) return(p->addr);		/* name found */
	
	if (p->next==NULL)				/* no such name, add a new one at end*/
	{								
		p->next=new_name();
		strcpy(p->next->name,in_name);
		p->next->addr=new_node();
		p->next->next=NULL;
		p->next->addr->node_id=in_id;
		if (in_id=='v') strcpy(p->next->addr->node_data.va_term.v_name,in_name);
		if (in_id=='c') 
		{
			strcpy(p->next->addr->node_data.cn_term.c_name,in_name);
			p->next->addr->node_data.cn_term.c_value=123.45;
			/* any initial value other than 0 and 1 */
		}
		return(p->next->addr);
	}
}
/*-----------------------------------------------------------------*/

/*----------------function to return a pointer to new func_elem---------*/
funcptr new_func()
{
	funcptr p;
	
	p=(funcptr) mxCalloc(1,sizeof(struct func_elem));
	if (p==NULL) 
	{
		mexErrMsgTxt("ERROR! Out of Memory!");
	};
	return (p);
}
/*-----------------------------------------------------------------*/


/*----------------function to store the pointer to the root of a function---------*/
store_func(head, in_name, root)

funcptr head;
char in_name[];
nodeptr root;

{
	funcptr p;
	
	if (head==NULL)				/* empty list */
	{
		p=new_func();
		func_header=p;
		strcpy(p->fname,in_name);
		p->faddr=root;
		p->nextf=NULL;
		return;
	}
	
	p=head;	
	while (p->nextf!=NULL)	p=p->nextf;
	
	if (p->nextf==NULL)				/* add the root of a new function at end*/
	{								
		p->nextf=new_func();
		strcpy(p->nextf->fname,in_name);
		p->nextf->faddr=root;
		p->nextf->nextf=NULL;
		return;
	}
}
/*-----------------------------------------------------------------*/


/*---------------function to return a pointer to the basic term------*/
nodeptr   basic_term(i, j, t)

int i,j;
char t;

{	
	
	nodeptr  p, pt[12];
	char	v_name[MAX_NAME];
	int ii,jj;
	
	p=new_node();
	p->node_id='b';
	if (t=='1') p->node_data.bi_term.oprt='+';
	if (t=='2') p->node_data.bi_term.oprt='-';
	
	p->node_data.bi_term.left=new_node();
	p->node_data.bi_term.right=new_node();	
	pt[1]=p;
	
	p=pt[1]->node_data.bi_term.left;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	p->node_data.bi_term.left=new_node();
	p->node_data.bi_term.right=new_node();
	pt[2]=p;
	
	p=pt[1]->node_data.bi_term.right;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	p->node_data.bi_term.left=new_node();
	p->node_data.bi_term.right=new_node();
	pt[3]=p;
	
	p=pt[2]->node_data.bi_term.left;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	pt[4]=p;
	
	p=pt[2]->node_data.bi_term.right;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	p->node_data.bi_term.right=new_node();
	pt[5]=p;
	
	p=pt[3]->node_data.bi_term.left;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	p->node_data.bi_term.left=new_node();
	pt[6]=p;
	
	p=pt[3]->node_data.bi_term.right;
	p->node_id='b';
	p->node_data.bi_term.oprt='*';
	pt[7]=p;

	if (t=='1') sprintf(v_name,"b[%d,%d]",i,j);
	if (t=='2') sprintf(v_name,"g[%d,%d]",i,j);
	pt[4]->node_data.bi_term.left=find_node(name_header,v_name,'c');
		
	sprintf(v_name,"e[%d]",i);
	pt[4]->node_data.bi_term.right=find_node(name_header,v_name,'v');
	 
	sprintf(v_name,"e[%d]",j);
	pt[5]->node_data.bi_term.left=find_node(name_header,v_name,'v');
	
	p=pt[5]->node_data.bi_term.right;
	p->node_id='u';
	p->node_data.un_term.oprt='s';				/* s for sin */
	p->node_data.un_term.next=new_node();
	pt[8]=p;
	
	p=pt[6]->node_data.bi_term.left;
	p->node_id='u';
	p->node_data.un_term.oprt='y';				/* y for cos */
	p->node_data.un_term.next=new_node();
	pt[9]=p;
	
	pt[6]->node_data.bi_term.right=pt[5]->node_data.bi_term.left;
	
	pt[7]->node_data.bi_term.left=pt[4]->node_data.bi_term.right;
	
	if (t=='1') sprintf(v_name,"g[%d,%d]",i,j);
	if (t=='2') sprintf(v_name,"b[%d,%d]",i,j);
	pt[7]->node_data.bi_term.right=find_node(name_header,v_name,'c');
	
	p=pt[8]->node_data.un_term.next;
	p->node_id='b';
	p->node_data.bi_term.oprt='-';
	pt[10]=p;
	
	p=pt[9]->node_data.un_term.next;
	p->node_id='b';
	p->node_data.bi_term.oprt='-';
	pt[11]=p;
	
	/* the following statements are for the case bus1 is the swing bus,
		if only basic equations are needed, only the statements in 'else'
		should be excuted */
	
	/* !!!!!!!!  need to form TWO (ti-tj)'s one for sin term one for cos term !!!!!!!!*/
	if (i==1)
	{
		pt[10]->node_data.bi_term.left=zero;
		pt[11]->node_data.bi_term.left=zero;
	}
	else
	{		
		ii=i-1;
		sprintf(v_name,"th[%d]",ii);
		pt[10]->node_data.bi_term.left=find_node(name_header,v_name,'v');
		pt[11]->node_data.bi_term.left=find_node(name_header,v_name,'v');
	};
	
	if (j==1)
	{
		pt[10]->node_data.bi_term.right=zero;
		pt[11]->node_data.bi_term.right=zero;
	}
	else
	{		
		jj=j-1;
		sprintf(v_name,"th[%d]",jj);
		pt[10]->node_data.bi_term.right=find_node(name_header,v_name,'v');
		pt[11]->node_data.bi_term.right=find_node(name_header,v_name,'v');
	};	

	return (pt[1]);
}
/*---------------------------------------------------------------*/


/*----------------function to return pointer to f1_term-----------*/
nodeptr f1_term(zi,zj,zn,i, j, t)

double zi[];
double zj[];
int zn;

int i,j;

char t;

{
	nodeptr p;
	int count, zero_term;
	
	zero_term=0;
	
/* test for zero term and set the flag */
	
	for (count=0; count<=zn-1; count++)
	{
	if ((i==(int) zi[count])&&(j==(int) zj[count]))
		{
			zero_term=1;
			break;
		}
	}

/* form the expressions */
	
	if (j==1){
		if (zero_term==1) p=zero;	
		else p=basic_term(i,j,t);
		}
	
	else if (zero_term==1) p=f1_term(zi,zj,zn,i,j-1,t);
		else{
			p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='+';
			p->node_data.bi_term.left=f1_term(zi,zj,zn,i,j-1,t);
			if (t=='1') p->node_data.bi_term.right=basic_term(i,j,t);	
			if (t=='2') p->node_data.bi_term.right=basic_term(i,j,t);
			};
	
	return(p);
}
/*---------------------------------------------------------------*/


build_model(zi,zj,zn)
double zi[];
double zj[];
int zn;

{
	int i,j,k;
	nodeptr p, p1, root1, root_sw, simp();
	char	f_name[MAX_NAME];
	char	v_name[MAX_NAME];
		
	for (i=1; i<=n_gen+m_pv+s_pq; i++)
	{
		j=n_gen+m_pv+s_pq;
		root1=f1_term(zi,zj,zn,i,j,'1');	
		
		for (k=1; k<=5+n_gen+m_pv+s_pq; k++) root1=simp(root1);
		
		p=new_node();
		p->node_id='b';
		p->node_data.bi_term.oprt='-';
		p->node_data.bi_term.left=root1;
		sprintf(v_name,"p[%d]",i);
		p->node_data.bi_term.right=find_node(name_header,v_name,'c');
		
		sprintf(f_name,"f1[%d,1]:=", i);
		store_func(func_header, f_name, p);		
		
		if (i>n_gen+m_pv) 
		{
			j=n_gen+m_pv+s_pq;	
			root1=f1_term(zi,zj,zn,i,j,'2');
			for (k=1; k<=5+n_gen+m_pv+s_pq; k++) root1=simp(root1);	
			
			p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='-';
			p->node_data.bi_term.left=root1;
			sprintf(v_name,"q[%d]",i);
			p->node_data.bi_term.right=find_node(name_header,v_name,'c');	
			
			sprintf(f_name,"f2[%d,1]:=", i-n_gen-m_pv);
			store_func(func_header, f_name, p);
			
		}
	}
}

