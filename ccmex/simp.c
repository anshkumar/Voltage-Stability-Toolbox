#include "global.h"
extern nodeptr zero, one, mi_one;

nodeptr simp(nodeptr fpt)
{
	nodeptr p;
	
	p=fpt;
	
	switch (fpt->node_id) {
	 case 'b':
		switch (fpt->node_data.bi_term.oprt) 
		{
		 case '+':
		 	if ((fpt->node_data.bi_term.left->node_id !='c')&&
				(fpt->node_data.bi_term.right->node_id !='c'))
			 {
				fpt->node_data.bi_term.left=simp(fpt->node_data.bi_term.left);
				fpt->node_data.bi_term.right=simp(fpt->node_data.bi_term.right);
				break;
			 };
			 
		 	if ((fpt->node_data.bi_term.left->node_id=='c')&&
		 		(fpt->node_data.bi_term.left->node_data.cn_term.c_value==0.0))
		 	 {
		 	 	p=fpt->node_data.bi_term.right;
		 /*		mxFree(fpt);		*/
		 		break;
		 	 };
		 	 
		 	if ((fpt->node_data.bi_term.right->node_id=='c')&&
		 		(fpt->node_data.bi_term.right->node_data.cn_term.c_value==0.0))
		 	 {
		 		p=fpt->node_data.bi_term.left;
		 /*		mxFree(fpt);	*/
		 		break;
		 	 };
		 	 
		 	if (((fpt->node_data.bi_term.left->node_id=='c')&&
		 		(fpt->node_data.bi_term.left->node_data.cn_term.c_value==0.0))&&
		 		((fpt->node_data.bi_term.right->node_id=='c')&&
		 		(fpt->node_data.bi_term.right->node_data.cn_term.c_value==0.0)))
		 	 {
		 /*		mxFree(fpt);	*/
		 		p=zero;
		 	 };
		 	 break;
			 
		 case '-':
		 	 if ((fpt->node_data.bi_term.left->node_id=='c')&&
		 		(strcmp(fpt->node_data.bi_term.left->node_data.cn_term.c_name,
		 				fpt->node_data.bi_term.right->node_data.cn_term.c_name)==0.0)||
		 		(fpt->node_data.bi_term.right->node_id=='v')&&
		 		(strcmp(fpt->node_data.bi_term.left->node_data.va_term.v_name,
		 				fpt->node_data.bi_term.right->node_data.va_term.v_name)==0.0))
		 	{
		/* 		mxFree(fpt);	*/
		 		p=zero;	
				break;	
		 	}	 
		 
		 	if ((fpt->node_data.bi_term.left->node_id !='c')&&
				(fpt->node_data.bi_term.right->node_id !='c'))
			 {
				fpt->node_data.bi_term.left=simp(fpt->node_data.bi_term.left);
				fpt->node_data.bi_term.right=simp(fpt->node_data.bi_term.right);
				break;
			 };
			 
		 	if ((fpt->node_data.bi_term.right->node_id=='c')&&
		 		(fpt->node_data.bi_term.right->node_data.cn_term.c_value==0.0))
		 	 {
		 		p=fpt->node_data.bi_term.left;
		/*		mxFree(fpt);	*/
		 		break;	
		 	 };
		 	 
		 	 if (((fpt->node_data.bi_term.left->node_id=='c')&&
		 		  (fpt->node_data.bi_term.left->node_data.cn_term.c_value==0.0))&&
		 		 ((fpt->node_data.bi_term.right->node_id=='c')&&
		 		  (fpt->node_data.bi_term.right->node_data.cn_term.c_value==1.0)))
		 	 {
		 		p=mi_one;
		/*		mxFree(fpt);	*/
		 		break;	
		 	 };
		 	 
		 	if ((fpt->node_data.bi_term.left->node_id=='c')&&
		 		(fpt->node_data.bi_term.left->node_data.cn_term.c_value==0.0)&&
		 		(fpt->node_data.bi_term.right->node_id=='c')&&
		 		(fpt->node_data.bi_term.right->node_data.cn_term.c_value==0.0)) 
		 	{
		 /*		mxFree(fpt);	*/
		 		p=zero;		 
		 	 };
		 	 break;
		 	
		 case '*':
		 	if ((fpt->node_data.bi_term.left->node_id !='c')&&
				(fpt->node_data.bi_term.right->node_id !='c'))
			 {
				fpt->node_data.bi_term.left=simp(fpt->node_data.bi_term.left);
				fpt->node_data.bi_term.right=simp(fpt->node_data.bi_term.right);
				break;
			 };
			 
			 if (((fpt->node_data.bi_term.left->node_id=='c')&&
		 		  (fpt->node_data.bi_term.left->node_data.cn_term.c_value==1.0))&&
		 		 ((fpt->node_data.bi_term.right->node_id=='c')&&
		 		  (fpt->node_data.bi_term.right->node_data.cn_term.c_value==1.0))) 
		 	{
		/* 		mxFree(fpt);	*/
		 		p=one;	
				break;	 		
		 	 };
			 
			 if ((fpt->node_data.bi_term.left->node_id =='c')&&
			 	 (fpt->node_data.bi_term.left->node_data.cn_term.c_value==1.0))
		 	 {
		 	 	p=simp(fpt->node_data.bi_term.right);
		/* 	 	mxFree(fpt);	*/
				break;
			 };
		 		
		 	 if ((fpt->node_data.bi_term.right->node_id =='c')&&
		 	 	 (fpt->node_data.bi_term.right->node_data.cn_term.c_value==1.0))
		 	 {
		 	 	p=simp(fpt->node_data.bi_term.left);
		/* 	 	mxFree(fpt);	*/
				break;
			 };								
			 
			 if (((fpt->node_data.bi_term.left->node_id=='c')&&
		 		  (fpt->node_data.bi_term.left->node_data.cn_term.c_value==0))||
		 		 ((fpt->node_data.bi_term.right->node_id=='c')&&
		 		  (fpt->node_data.bi_term.right->node_data.cn_term.c_value==0))) 
		 	{
		/* 		mxFree(fpt);	*/
		 		p=zero;	
				break;	 		
		 	 };
			 
			 if ((fpt->node_data.bi_term.left->node_id =='c')&&
			 	 (fpt->node_data.bi_term.left->node_data.cn_term.c_value!=0.0))
		 	 {
		 	 	fpt->node_data.bi_term.right=simp(fpt->node_data.bi_term.right);
				break;
			 };
		 		
		 	 if ((fpt->node_data.bi_term.right->node_id =='c')&&
		 	 	 (fpt->node_data.bi_term.right->node_data.cn_term.c_value!=0.0))
		 	 {
		 	 	fpt->node_data.bi_term.left=simp(fpt->node_data.bi_term.left);
				break;
			 };								
			 
		 	 break;
		}; break;
		case 'u':
			switch (fpt->node_data.un_term.oprt)
			{
			case 's':
				if ((fpt->node_data.un_term.next->node_id =='c')&&
		 	 		(fpt->node_data.un_term.next->node_data.cn_term.c_value==0.0))
		 	 	{
		/* 			mxFree(fpt);	*/
		 			p=zero;	
					break;
		 	 	}
		 	 	else 
		 	 	{
					fpt->node_data.un_term.next=simp(fpt->node_data.un_term.next);
					break;
				}
				
			case 'y':
				if ((fpt->node_data.un_term.next->node_id =='c')&&
		 	 		(fpt->node_data.un_term.next->node_data.cn_term.c_value==0.0))
		 	 	{
		 /*			mxFree(fpt);	*/
		 			p=one;	
					break;
		 	 	}
		 	 	else 
		 	 	{
					fpt->node_data.un_term.next=simp(fpt->node_data.un_term.next);
					break;
				}
			};	/* end of unary */
		
	}; /* end of switch */
	return(p);
}
