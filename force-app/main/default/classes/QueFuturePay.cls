public without sharing class QueFuturePay  implements Queueable{
    private id tcc;
	public QueFuturePay(id tcl) {
		tcc=tcl;
    }
	public void execute(QueueableContext context) {
       FuturePaySend.SendPay(tcc); 		
    }
}