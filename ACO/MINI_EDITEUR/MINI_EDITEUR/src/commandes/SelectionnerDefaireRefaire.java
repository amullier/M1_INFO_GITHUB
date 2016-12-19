package commandes;

import classes.Buffer;
import classes.GestionDefaireRefaire;
import classes.MoteurImpl;
import classes.Selection;
import memento.Memento;
import memento.MementoEtatMoteur;

public class SelectionnerDefaireRefaire implements CommandeDefaireRefaire {
	private Commande commande_selection;
	
	private MementoEtatMoteur memento;
	private GestionDefaireRefaire gestionnaire_dr; //Caretaker du memento 2
	
	public SelectionnerDefaireRefaire(Commande c,GestionDefaireRefaire g){
		commande_selection = c;
		gestionnaire_dr = g;
	}
	
	@Override
	public void execute() {
		commande_selection.execute();
		
		//Ajouter l'instruction et le mémento à la pile de Defaire/Refaire
		gestionnaire_dr.ajoutCommandeDefaireRefaire((CommandeDefaireRefaire) this);
		
	}

	@Override
	public Memento getMemento() {
		
		//On récupère l'état actuel du buffer
		MoteurImpl moteur = ((Selectionner) commande_selection).getMoteur();
		Buffer buffer = moteur.getBuffer();
		Selection selection = new Selection(buffer.getSelection());
		
		//On crée le mémento et on stocke l'état du buffer
		memento = new MementoEtatMoteur(buffer.getContenu(), selection);
		
		return memento;
	}

	@Override
	public void setMemento(Memento m) {
		// TODO Auto-generated method stub
		this.memento = (MementoEtatMoteur) m;
		
	}
}
