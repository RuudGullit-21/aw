
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТестСоединенияССерверомРепликации(Команда)
	
	ТестСоединенияССерверомРепликацииНаСервере();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТестСоединенияССерверомРепликацииНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
		ТекстОшибки = "";
		НастройкиРепликации = ItobРепликация.НастройкиРепликацииПоУмолчанию();
		ЗаполнитьЗначенияСвойств(НастройкиРепликации, Объект);
		
		Если НЕ ItobРепликация.ТестСоединенияССерверомРепликации(НастройкиРепликации, ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки); 	
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Соединение успешно установлено");
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти 

