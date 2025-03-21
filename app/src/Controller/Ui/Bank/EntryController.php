<?php

namespace App\Controller\Ui\Bank;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/bank/entry', name: 'app_bank_entry')]
class EntryController extends AbstractController
{
    #[Route('/', name: 'index')]
    public function index(): Response
    {
        // Données fictives pour les catégories
        $categories = [
            ['id' => 1, 'name' => 'Salaire'],
            ['id' => 2, 'name' => 'Loyer'],
            ['id' => 3, 'name' => 'Courses'],
            ['id' => 4, 'name' => 'Transport'],
            ['id' => 5, 'name' => 'Loisirs'],
        ];

        // Données fictives pour les entrées
        $entries = [
            [
                'id' => 1,
                'date' => new \DateTime('2024-03-15'),
                'description' => 'Salaire mensuel',
                'amount' => 2500.00,
                'category' => $categories[0]
            ],
            [
                'id' => 2,
                'date' => new \DateTime('2024-03-10'),
                'description' => 'Loyer mars',
                'amount' => -800.00,
                'category' => $categories[1]
            ],
            [
                'id' => 3,
                'date' => new \DateTime('2024-03-12'),
                'description' => 'Courses Carrefour',
                'amount' => -150.50,
                'category' => $categories[2]
            ],
            [
                'id' => 4,
                'date' => new \DateTime('2024-03-14'),
                'description' => 'Titre de transport',
                'amount' => -75.00,
                'category' => $categories[3]
            ],
            [
                'id' => 5,
                'date' => new \DateTime('2024-03-16'),
                'description' => 'Cinéma',
                'amount' => -25.00,
                'category' => $categories[4]
            ],
            [
                'id' => 6,
                'date' => new \DateTime('2024-03-17'),
                'description' => 'Restaurant',
                'amount' => -45.00,
                'category' => $categories[4]
            ],
            [
                'id' => 7,
                'date' => new \DateTime('2024-03-18'),
                'description' => 'Courses Lidl',
                'amount' => -89.99,
                'category' => $categories[2]
            ],
            [
                'id' => 8,
                'date' => new \DateTime('2024-03-19'),
                'description' => 'Prime de performance',
                'amount' => 500.00,
                'category' => $categories[0]
            ],
        ];

        return $this->render('bank/entry/index.html.twig', [
            'entries' => $entries,
            'categories' => $categories
        ]);
    }
}
