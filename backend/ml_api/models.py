from django.db import models


# Create your models here.
class SentimentAnalysis(models.Model):
    input_text = models.TextField()
    prediction_label = models.CharField(max_length=20)
    prediction_score = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        pred_cls, pred_val = self.prediction_label, self.prediction_score
        return f'{self.input_text[:20]} - {pred_cls} ({pred_val:.3f})'
