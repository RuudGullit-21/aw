////////////////////////////////////////////////////////////////////////////////
// Команды для трекеров (клиент, сервер)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет команду на трекер.
//
// Параметры:
//  Терминал				 - СправочникСсылка.ItobТерминалы	 - Указатель на терминал.
//  Команда					 - Строка							 - Команда.
//  ТекстОшибки				 - Строка							 - Текст ошибки.
//  ПисатьВЖурнал			 - Булево							 - Результат писать в журнал регистрации.
//  ПоказыватьПредупреждение - Булево							 - Флаг отображения предупреждения.
// 
// Возвращаемое значение:
//  Булево - Результат выполнения команды.
//
Функция ВыполнитьКомандуНаСервере(Терминал, Команда, ТекстОшибки, ПисатьВЖурнал = Ложь, ПоказыватьПредупреждение = Ложь) Экспорт
	Результат = Неопределено;
	
	#Если НаКлиенте Тогда
		Результат = ItobКомандыДляТрекеровКлиент.ВыполнитьКомандуНаСервере(Терминал, Команда, ТекстОшибки, ПисатьВЖурнал, ПоказыватьПредупреждение);
	#Иначе
		Результат = ItobКомандыДляТрекеров.ВыполнитьКомандуНаСервере(Терминал, Команда, ТекстОшибки, ПисатьВЖурнал);
	#КонецЕсли
	
	Возврат Результат;
КонецФункции

#КонецОбласти
