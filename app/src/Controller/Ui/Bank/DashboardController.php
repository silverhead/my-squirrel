<?php

namespace App\Controller\Ui\Bank;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\UX\Chartjs\Builder\ChartBuilderInterface;
use Symfony\UX\Chartjs\Model\Chart;

#[Route('/bank', name: 'bank_')]
class DashboardController extends AbstractController
{
    #[Route('/dashboard/{id}', name: 'dashboard')]
    public function dashboard(
        ChartBuilderInterface $chartBuilder,
        int $id
    ): Response {
        $widgets = [
            (object) [
                'title' => 'Solde total',
                'amount' => 12345.67,
                'percentage' => 2.5,
                'bgColor' => 'bg-primary',
                'textColor' => 'text-primary-content',
            ],
            (object) [
                'title' => 'Revenus mensuels',
                'amount' => 3456.78,
                'percentage' => 1.2,
                'bgColor' => 'bg-success',
                'textColor' => 'text-success-content',
            ],
            (object) [
                'title' => 'Dépenses mensuelles',
                'amount' => 2345.67,
                'percentage' => -0.8,
                'bgColor' => 'bg-warning',
                'textColor' => 'text-error-content',
            ],
            (object) [
                'title' => 'Économie mensuelle',
                'amount' => 1234.56,
                'percentage' => 1.5,
                'bgColor' => 'bg-info',
                'textColor' => 'text-info-content',
            ],
        ];


        $chart = $chartBuilder->createChart(Chart::TYPE_LINE);
        $chart->setData([
            'labels' => ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'],
            'datasets' => [
                [
                    'label' => 'Dépenses mensuelles',
                    'backgroundColor' => '#1e40af20',
                    'borderColor' => '#1e40af',
                    'data' => [2500, 2800, 2300, 3000, 2789, 3200],
                    'tension' => 0.1,
                    'fill' => true,
                ],
            ],
        ]);
        $chart->setOptions([
            'responsive' => true,
            'maintainAspectRatio' => false,
            'plugins' => [
                'legend' => [
                    'position' => 'top',
                ],
            ],
            'scales' => [
                'y' => [
                    'beginAtZero' => true,
                ],
            ],
        ]);

        $chart2 = $chartBuilder->createChart(Chart::TYPE_DOUGHNUT);
        $chart2->setData([
            'labels' => ['Logement', 'Alimentation', 'Transport', 'Loisirs', 'Autres'],
            'datasets' => [
                [
                    'data' => [40, 20, 15, 15, 10],
                    'backgroundColor' => ['#1e40af', '#4f46e5', '#f59e0b', '#6b7280', '#1f2937'],
                ],
            ],
        ]);
        $chart2->setOptions([
            'responsive' => true,
            'maintainAspectRatio' => false,
            'plugins' => [
                'legend' => [
                    'position' => 'right',
                ],
            ],
        ]);

        $chartComponent = [
            (object) [
                'title' => 'Évolution des dépenses',
                'chart' => $chart,
            ],
            (object) [
                'title' => 'Répartition des dépenses',
                'chart' => $chart2,
            ],
        ];

        return match ($id) {
            1 => $this->render('bank/dashboard_ws.html.twig', [
                'charts' => $chartComponent,
                'widgets' => $widgets,
            ]),
            2 => $this->render('bank/dashboard.html.twig', [
                'charts' => $chartComponent,
                'widgets' => $widgets,
            ]),
            default => $this->render('bank/dashboard_copy.html.twig', [
                'charts' => $chartComponent,
                'widgets' => $widgets,
            ]),
        };
    }
}
