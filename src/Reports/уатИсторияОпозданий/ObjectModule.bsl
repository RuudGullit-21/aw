#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Если НЕ Константы.уатУчетПланФактаПоМаршрутуВМаршрутныхЛистах.Получить() Тогда
		
		ПолеОпозданиеФактЧЧММ = СхемаКомпоновкиДанных.ВычисляемыеПоля.Найти("ОпозданиеФактЧЧММ");
		Если ПолеОпозданиеФактЧЧММ <> Неопределено Тогда
			ПолеОпозданиеФактЧЧММ.ОграничениеИспользования.Поле = Истина;
		КонецЕсли;
		
		НаборДанных1 = СхемаКомпоновкиДанных.НаборыДанных.Найти("НаборДанных1");
		Если НаборДанных1 <> Неопределено Тогда
			ПолеОпозданиеФактМинут = НаборДанных1.Поля.Найти("ОпозданиеФактМинут");
			Если ПолеОпозданиеФактМинут <> Неопределено Тогда
				ПолеОпозданиеФактМинут.ОграничениеИспользования.Поле = Истина;
			КонецЕсли;
			
			ПолеПрибытиеФакт = НаборДанных1.Поля.Найти("ПрибытиеФакт");
			Если ПолеПрибытиеФакт <> Неопределено Тогда
				ПолеПрибытиеФакт.ОграничениеИспользования.Поле = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
