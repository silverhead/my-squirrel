<?php

namespace App\Controller\Ui\Bank;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class AccountController extends AbstractController
{
    #[Route('/bank/account', name: 'app_bank_account_index', methods: ['GET'])]
    public function index(): Response
    {
        $accounts = [
            [
                'id' => 1,
                'bank' => 'Caisse d\'Épargne',
                'name' => 'Compte Courant',
                'balance' => 2547.89,
                'icon' => 'https://storage.googleapis.com/endurance-apps-liip/media/cache/theming_no_filter_grid_fs/56680f8a9b3e9da5978b47d7',
            ],
            [
                'id' => 2,
                'bank' => 'Crédit Agricole',
                'name' => 'Compte Épargne',
                'balance' => 15780.45,
                'icon' => 'https://upload.wikimedia.org/wikipedia/fr/a/a6/Cr%C3%A9dit_Agricole.svg',
            ],
            [
                'id' => 3,
                'bank' => 'Société Générale',
                'name' => 'Compte Joint',
                'balance' => 4230.12,
                'icon' => 'https://icons.veryicon.com/png/o/business/bank-logo-collection/logo-of-societe-generale.png',
            ],
        ];

        return $this->render('bank/account/index.html.twig', [
            'accounts' => $accounts,
        ]);
    }

    #[Route('/bank/account/{id}', name: 'app_bank_account_edit', methods: ['GET', 'POST'])]
    public function edit(int $id): Response
    {

        return match ($id) {
            1 => $this->render('bank/account/edit.html.twig', [
                'id' => $id,
            ]),
            2 => $this->render('bank/account/edit_copy.html.twig', [
                'id' => $id,
            ]),
            3 => $this->render('bank/account/edit.html.twig', [
                'id' => $id,
            ]),
            default => $this->redirectToRoute('app_bank_account_index'),
        };
        
        return $this->render('bank/account/edit.html.twig', [
            'id' => $id,
        ]);
    }
}
