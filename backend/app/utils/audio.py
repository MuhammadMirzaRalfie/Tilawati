"""Audio processing utilities for Tilawati."""

import os


def get_audio_duration(audio_path: str) -> float:
    """Get duration of audio file in seconds.
    
    TODO: Implement with librosa when AI model is integrated.
    Returns estimated duration for now.
    """
    if not os.path.exists(audio_path):
        return 0.0
    
    # Estimate based on file size (~16KB per second for WAV 16kHz mono)
    file_size = os.path.getsize(audio_path)
    estimated_duration = file_size / 16000
    return round(estimated_duration, 1)


def validate_audio_format(filename: str) -> bool:
    """Check if audio file format is supported."""
    supported = {'.wav', '.mp3', '.m4a', '.ogg', '.webm'}
    ext = os.path.splitext(filename)[1].lower()
    return ext in supported
