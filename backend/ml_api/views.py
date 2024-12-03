import random
import logging

from rest_framework.views import APIView
from rest_framework.response import Response

from .models import SentimentAnalysis


# Create a logger instance
logger = logging.getLogger(__name__)


class SentimentAnalysisView(APIView):
    def post(self, request):
        text = request.data.get('text')
        if not text:
            return Response({'error': 'Text input is required'}, status=400)

        # Make prediction
        #@TODO: for now simply random number (0, 1)
        random.seed(len(text.split()))
        pred = random.random()
        result = {'label': 'POS' if pred > .5 else 'NEG', 'score': pred}
        prediction_label, prediction_score = result['label'], result['score']

        # Save to databasa:
        _ = SentimentAnalysis.objects.create(
            input_text=text,
            prediction_label=prediction_label,
            prediction_score=prediction_score
        )

        # Log the prediction
        logger.info(
            f"Saved prediction: "
            f"{_.id} - {_.input_text} - {_.prediction_label} ({_.prediction_score})"
        )

        return Response({
            'id': _.id,
            'text': text,
            'label': prediction_label,
            'score': prediction_score
        })
